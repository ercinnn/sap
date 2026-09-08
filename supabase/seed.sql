-- Örnek test verisi (Jean Pantolon senaryosu). Idempotent şekilde
-- yazılmıştır: mevcut kayıtlar üzerine tekrar tekrar çalıştırılabilir.
-- Supabase Dashboard > SQL Editor'de schema.sql'den SONRA çalıştırın.

insert into materials (material_number, description, material_type, base_unit) values
  ('FIN-JEAN-001', 'Jean Pantolon (Slim Fit, Indigo)', 'finished_good', 'PC'),
  ('FAB-DENIM-12OZ', 'Denim Kumaş 12oz', 'fabric', 'MT'),
  ('ACC-BUTTON-JEAN', 'Jean Düğmesi 20mm', 'button', 'PC'),
  ('ACC-RIVET-9MM', 'Rivet 9mm', 'rivet', 'PC'),
  ('CHEM-WASH-ENZYME', 'Enzim Yıkama Kimyasalı', 'wash_chemical', 'LT'),
  ('LBL-BRAND-001', 'Marka Etiketi', 'label', 'PC'),
  ('BOX-SHIP-M', 'Sevkiyat Koli (M)', 'box', 'PC')
on conflict (material_number) do nothing;

insert into work_centers (code, name, work_center_type) values
  ('WC-10', 'Kesimhane', 'cutting'),
  ('WC-20', 'Dikim Bandı 1', 'sewing'),
  ('WC-30', 'Yıkama Tesisi', 'washing'),
  ('WC-40', 'Ütü / Paket', 'ironing_packing')
on conflict (code) do nothing;

-- FIN-JEAN-001 için iş planı: 10-Kesim -> 20-Dikim -> 30-Yıkama -> 40-Kalite/Paket
insert into routings (material_id, operation_sequence, work_center_id, operation_description, standard_time_minutes)
select m.id, r.seq, wc.id, r.description, r.minutes
from materials m
join work_centers wc on wc.code = r.wc_code
cross join lateral (values
  (10, 'WC-10', 'Kumaş kesimi', 5.0),
  (20, 'WC-20', 'Parça dikimi ve montaj', 25.0),
  (30, 'WC-30', 'Enzim yıkama', 45.0),
  (40, 'WC-40', 'Ütü, kalite kontrol, paketleme', 8.0)
) as r(seq, wc_code, description, minutes)
where m.material_number = 'FIN-JEAN-001'
on conflict (material_id, operation_sequence) do nothing;

-- FIN-JEAN-001 için BOM (bill_of_materials'ta unique kısıt olmadığından
-- NOT EXISTS ile idempotent hale getirildi)
insert into bill_of_materials (parent_material_id, component_material_id, quantity, unit, scrap_percentage)
select p.id, c.id, b.qty, b.unit, b.scrap
from materials p
join materials c on c.material_number = b.component_number
cross join lateral (values
  ('FAB-DENIM-12OZ', 1.4, 'MT', 3.0),
  ('ACC-BUTTON-JEAN', 1.0, 'PC', 0.0),
  ('ACC-RIVET-9MM', 6.0, 'PC', 1.0),
  ('CHEM-WASH-ENZYME', 0.05, 'LT', 0.0),
  ('LBL-BRAND-001', 1.0, 'PC', 0.0),
  ('BOX-SHIP-M', 0.083, 'PC', 0.0)
) as b(component_number, qty, unit, scrap)
where p.material_number = 'FIN-JEAN-001'
and not exists (
  select 1 from bill_of_materials existing
  where existing.parent_material_id = p.id
  and existing.component_material_id = c.id
);

insert into production_orders (order_number, material_id, order_quantity, status, planned_start_date, planned_end_date)
select o.order_number, m.id, o.qty, o.status, o.start_date, o.end_date
from materials m
cross join lateral (values
  ('PO-2026-1001', 500.0, 'released', date '2026-09-10', date '2026-09-17'),
  ('PO-2026-1002', 300.0, 'in_process', date '2026-09-08', date '2026-09-14'),
  ('PO-2026-1003', 750.0, 'created', date '2026-09-15', date '2026-09-24')
) as o(order_number, qty, status, start_date, end_date)
where m.material_number = 'FIN-JEAN-001'
on conflict (order_number) do nothing;
