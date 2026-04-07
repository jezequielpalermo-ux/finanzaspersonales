-- ═══════════════════════════════════════════════════════
--  CONTROL DE GASTOS — Supabase Schema
--  Correr en: Supabase Dashboard → SQL Editor → New query
-- ═══════════════════════════════════════════════════════

-- Tabla principal: guarda todo el estado como un JSON
create table if not exists gastos_state (
  id          integer primary key default 1,
  data        jsonb not null default '{}',
  updated_by  text,
  updated_at  timestamptz default now()
);

-- Tabla de versiones: historial para recuperación
create table if not exists gastos_versions (
  id          bigserial primary key,
  data        jsonb,
  saved_by    text,
  created_at  timestamptz default now()
);

-- Row Level Security (permitir acceso público — app personal)
alter table gastos_state   enable row level security;
alter table gastos_versions enable row level security;

create policy "Allow anon all on gastos_state"
  on gastos_state for all to anon
  using (true) with check (true);

create policy "Allow anon all on gastos_versions"
  on gastos_versions for all to anon
  using (true) with check (true);

-- Insertar fila inicial vacía (necesario para el primer upsert)
insert into gastos_state (id, data)
values (1, '{}')
on conflict (id) do nothing;
