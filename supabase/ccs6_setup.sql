-- Progetto Supabase «ccs 6» · Team LUOGO · creato il 2026-10-12
-- Sostituisce il progetto luogo-smartcity (settimana 4), che non risponde più.
-- Da eseguire una volta: Supabase → SQL Editor → New query → incolla → Run. Si può rieseguire senza duplicare.

-- ① Settimana 4 · scheda delle fonti (stessa struttura di supabase/evidence.sql)

create table if not exists public.evidence (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  item        text    not null check (char_length(btrim(item))   > 0),  -- nome della voce
  value       numeric not null,                                         -- solo il numero
  unit        text    not null check (char_length(btrim(unit))   > 0),  -- unità
  source      text    not null check (char_length(btrim(source)) > 0),  -- servizio · articolo · indirizzo
  queried_on  date    not null                                          -- data di consultazione
);

comment on table public.evidence is 'Scheda delle fonti del team LUOGO (Campus Sangmyung, 안서동 300)';

-- Permessi: RLS attiva + due policy. Nessuna policy di update/delete:
-- con la chiave publishable si può solo leggere e aggiungere righe.
alter table public.evidence enable row level security;

drop policy if exists "evidence_lettura" on public.evidence;
create policy "evidence_lettura"
  on public.evidence for select
  to anon, authenticated
  using (true);

drop policy if exists "evidence_inserimento" on public.evidence;
create policy "evidence_inserimento"
  on public.evidence for insert
  to anon, authenticated
  with check (queried_on <= current_date);  -- niente date di consultazione nel futuro

grant select, insert on public.evidence to anon, authenticated;

insert into public.evidence (item, value, unit, source, queried_on)
select v.* from (values
  ('Storico avvisi del piano di gestione su 안서동 300 — vigente 천안시 고시 제2023-216호 (decisione + tavola topografica 2023-08-01, efficace dal 2023-08-01)', 16, 'avvisi distinti 1986→2023', '토지이음, 도시계획 열람 → 관련 고시 정보 (eum.go.kr/web/cp/cv/cvUpisDet.jsp) · 천안시 고시 제2023-216호', date '2026-09-28'),
  ('Zone d''uso sul lotto 안서동 300 — prevalente 자연녹지지역, poi 보전녹지지역 e 제2종일반주거지역', 3, 'zone d''uso', '토지이음, 토지이용계획열람 → 지역지구등 지정여부 (eum.go.kr/web/ar/lu/luLandDet.jsp)', date '2026-09-28')
) as v(item, value, unit, source, queried_on)
where not exists (select 1 from public.evidence e where e.item = v.item);

-- ② Settimana 6 · catalogo dei grafici (una riga = una barra o uno spicchio)
create table if not exists public.catalog (
  id          text primary key,                                    -- es. ind6-15, lc-bosco
  chart       text    not null check (chart in ('confronto', 'composizione')),
  item_it     text    not null check (char_length(btrim(item_it)) > 0),
  item_ko     text    not null check (char_length(btrim(item_ko)) > 0),
  value       numeric not null,                                    -- solo il numero
  unit        text    not null check (char_length(btrim(unit)) > 0),
  share_pct   numeric,                                             -- quota dell'area (solo indicatore 6)
  cells       integer,                                             -- celle da 0,81 ha (solo copertura)
  highlight   boolean not null default false,                      -- unico colore di evidenza
  source      text    not null check (char_length(btrim(source)) > 0),
  queried_on  date    not null check (queried_on <= current_date),
  is_latest   boolean not null default true
);
comment on table public.catalog is 'Catalogo dei grafici della settimana 6 — team LUOGO (campus Sangmyung + 1 km)';
alter table public.catalog enable row level security;
drop policy if exists "catalog_lettura" on public.catalog;
create policy "catalog_lettura" on public.catalog for select to anon, authenticated using (true);
grant select on public.catalog to anon, authenticated;   -- con la chiave publishable: solo lettura

insert into public.catalog (id, chart, item_it, item_ko, value, unit, share_pct, cells, highlight, source, queried_on, is_latest) values
  ('ind6-10', 'confronto', 'Superficie idonea, pendenza ≤ 10 %', '적합 면적, 경사 ≤ 10 %', 52.65, 'ha', 16.9, null, false, 'SRTM 90 m (CGIAR-CSI v4.1) via OpenTopoData srtm90m · 3 condizioni: pendenza ≤ soglia, esposizione 135–225°, quota ≤ strada + 50 m', date '2026-10-12', true),
  ('ind6-15', 'confronto', 'Superficie idonea, pendenza ≤ 15 % (scenario base)', '적합 면적, 경사 ≤ 15 % (기본 시나리오)', 62.37, 'ha', 20.0, null, true, 'SRTM 90 m (CGIAR-CSI v4.1) via OpenTopoData srtm90m · 3 condizioni: pendenza ≤ soglia, esposizione 135–225°, quota ≤ strada + 50 m', date '2026-10-12', true),
  ('ind6-25', 'confronto', 'Superficie idonea, pendenza ≤ 25 %', '적합 면적, 경사 ≤ 25 %', 80.19, 'ha', 25.7, null, false, 'SRTM 90 m (CGIAR-CSI v4.1) via OpenTopoData srtm90m · 3 condizioni: pendenza ≤ soglia, esposizione 135–225°, quota ≤ strada + 50 m', date '2026-10-12', true),
  ('lc-edificato', 'composizione', 'Edificato', '시가지', 177.39, 'ha', null, 219, false, 'Impact Observatory/Esri, Sentinel-2 10 m Land Use/Land Cover 2025 · classe maggioritaria per cella di 90 m', date '2026-10-12', true),
  ('lc-bosco', 'composizione', 'Bosco', '산림', 115.83, 'ha', null, 143, true, 'Impact Observatory/Esri, Sentinel-2 10 m Land Use/Land Cover 2025 · classe maggioritaria per cella di 90 m', date '2026-10-12', true),
  ('lc-acqua', 'composizione', 'Acqua', '수면', 15.39, 'ha', null, 19, false, 'Impact Observatory/Esri, Sentinel-2 10 m Land Use/Land Cover 2025 · classe maggioritaria per cella di 90 m', date '2026-10-12', true),
  ('lc-prati', 'composizione', 'Prati e arbusti', '초지·관목', 3.24, 'ha', null, 4, false, 'Impact Observatory/Esri, Sentinel-2 10 m Land Use/Land Cover 2025 · classe maggioritaria per cella di 90 m', date '2026-10-12', true)
on conflict (id) do update set chart = excluded.chart, item_it = excluded.item_it, item_ko = excluded.item_ko, value = excluded.value,
  unit = excluded.unit, share_pct = excluded.share_pct, cells = excluded.cells, highlight = excluded.highlight,
  source = excluded.source, queried_on = excluded.queried_on, is_latest = excluded.is_latest;

-- ③ Verifica: deve restituire evidence 2 righe · catalog 7 righe · rls = true per entrambe
select c.relname as tabella, c.relrowsecurity as rls,
       (select count(*) from public.evidence) as righe_evidence, (select count(*) from public.catalog) as righe_catalog
from pg_class c where c.relname in ('evidence', 'catalog') and c.relnamespace = 'public'::regnamespace;
