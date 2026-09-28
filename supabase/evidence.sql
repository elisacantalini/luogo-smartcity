-- Settimana 4 extracurricolare · Team LUOGO
-- Tabella evidence = scheda delle fonti (voce · valore · unità · fonte · data di consultazione)
-- Da eseguire una volta in Supabase → SQL Editor → New query → Run.

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

-- Verifica rapida (deve restituire rowsecurity = true):
-- select relname, relrowsecurity as rowsecurity from pg_class where relname = 'evidence';
