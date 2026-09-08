-- FAZ 2 referans şeması. Veritabanı şemasının kendisi kullanıcı tarafından
-- yönetilir; bu dosya Flutter tarafındaki modellerin/repository'lerin
-- hangi tablo ve sütun adlarını beklediğinin tek doğru referansıdır.
-- Supabase Dashboard > SQL Editor'de çalıştırılabilir. Sütun adları
-- kasıtlı olarak İngilizce ve snake_case'tir.

create extension if not exists "pgcrypto";

-- 1) MATERIAL MASTER ---------------------------------------------------
create table if not exists materials (
  id uuid primary key default gen_random_uuid(),
  material_number text unique not null,
  description text not null,
  material_type text not null check (material_type in (
    'fabric', 'yarn', 'accessory', 'button', 'rivet',
    'wash_chemical', 'label', 'box', 'finished_good'
  )),
  base_unit text not null default 'PC',
  created_at timestamptz not null default now()
);

-- 2) BILL OF MATERIALS ---------------------------------------------------
create table if not exists bill_of_materials (
  id uuid primary key default gen_random_uuid(),
  parent_material_id uuid not null references materials(id) on delete cascade,
  component_material_id uuid not null references materials(id) on delete restrict,
  quantity numeric not null check (quantity > 0),
  unit text not null,
  scrap_percentage numeric not null default 0,
  created_at timestamptz not null default now()
);

-- 3) WORK CENTERS ---------------------------------------------------
create table if not exists work_centers (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  work_center_type text not null check (work_center_type in (
    'cutting', 'sewing', 'washing', 'ironing_packing'
  )),
  created_at timestamptz not null default now()
);

-- 4) ROUTINGS (İş Planı) ---------------------------------------------------
create table if not exists routings (
  id uuid primary key default gen_random_uuid(),
  material_id uuid not null references materials(id) on delete cascade,
  operation_sequence integer not null,
  work_center_id uuid not null references work_centers(id) on delete restrict,
  operation_description text not null,
  standard_time_minutes numeric not null default 0,
  created_at timestamptz not null default now(),
  unique (material_id, operation_sequence)
);

-- 5) PRODUCTION ORDERS ---------------------------------------------------
create table if not exists production_orders (
  id uuid primary key default gen_random_uuid(),
  order_number text unique not null,
  material_id uuid not null references materials(id) on delete restrict,
  order_quantity numeric not null check (order_quantity > 0),
  status text not null default 'created' check (status in (
    'created', 'released', 'in_process', 'completed', 'closed'
  )),
  planned_start_date date,
  planned_end_date date,
  created_at timestamptz not null default now()
);

-- 6) PRODUCTION CONFIRMATIONS (Operasyon Teyitleri) ------------------------
create table if not exists production_confirmations (
  id uuid primary key default gen_random_uuid(),
  production_order_id uuid not null references production_orders(id) on delete cascade,
  operation_sequence integer not null,
  confirmed_quantity numeric not null check (confirmed_quantity >= 0),
  scrap_quantity numeric not null default 0,
  confirmed_at timestamptz not null default now(),
  confirmed_by text
);

-- 7) MATERIAL MOVEMENTS (261 / 101) ---------------------------------------
create table if not exists material_movements (
  id uuid primary key default gen_random_uuid(),
  movement_type text not null check (movement_type in ('261', '101')),
  material_id uuid not null references materials(id) on delete restrict,
  production_order_id uuid references production_orders(id) on delete set null,
  quantity numeric not null check (quantity > 0),
  unit text not null,
  movement_date timestamptz not null default now(),
  created_by text
);

-- 8) RLS (Row Level Security) -------------------------------------------
-- Supabase, tablo oluştururken "Run and enable RLS" seçeneği ile RLS'i
-- otomatik açar. Henüz bir login/kullanıcı sistemi kurulmadığı için, anon
-- key'e (uygulamanın kullandığı public key) tüm tablolarda GEÇİCİ olarak
-- tam erişim veriyoruz. Faz'larda kullanıcı girişi eklendiğinde bu
-- policy'ler kaldırılıp rol/kullanıcı bazlı gerçek kısıtlamalarla
-- değiştirilmelidir - production'da anon'a "using (true)" bırakmayın.
do $$
declare
  t text;
begin
  foreach t in array array[
    'materials', 'bill_of_materials', 'work_centers', 'routings',
    'production_orders', 'production_confirmations', 'material_movements'
  ]
  loop
    execute format('alter table %I enable row level security;', t);
    execute format('drop policy if exists "dev_allow_all_anon" on %I;', t);
    execute format(
      'create policy "dev_allow_all_anon" on %I for all to anon, authenticated using (true) with check (true);',
      t
    );
  end loop;
end $$;
