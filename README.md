# Settimana 4 extracurricolare — Scheda delle fonti su Supabase · Team LUOGO

Consegna: LMS > Settimana 4 extracurricolare — PDF di 1 pagina con screenshot della pagina e di Table Editor,
indirizzo di deploy e repository nel testo — scadenza **2026-10-04, 23:59**.

## File

| File | Contenuto |
|---|---|
| `index.html` | pagina del team (settimana 3) + modulo e elenco della tabella `evidence`, in **한국어 / Italiano** (selettore in alto; link diretti `#ko` e `#it`) |
| `config.js` | URL del progetto e chiave **publishable** (unico posto da compilare) |
| `supabase/evidence.sql` | tabella, vincoli NOT NULL, RLS e policy di lettura/inserimento |

## Passi

1. **Progetto** — su supabase.com creare un progetto (es. `luogo-smartcity`, regione Seoul).
2. **Tabella** — SQL Editor → incollare `supabase/evidence.sql` → Run. In Table Editor controllare:
   nome `evidence`; `value` = numeric, `queried_on` = date; badge RLS attivo; 2 policy.
3. **Chiavi** — Connect → copiare Project URL e chiave `sb_publishable_…` in `config.js`.
   La chiave `sb_secret_…` non serve per questo compito: non copiarla da nessuna parte.
4. **Prova locale** — nella cartella: `python -m http.server 8000` → http://localhost:8000
   (i moduli ES non funzionano aprendo il file con doppio clic).
5. **Salvare le 2 righe** dal modulo della pagina (sotto).
6. **Deploy** — GitHub Pages, branch main, cartella / (root): https://elisacantalini.github.io/luogo-smartcity/
7. **Verifiche** — compilare il log qui sotto, poi commit e push.

## Le 2 righe (dal compito settimana 4 del corso principale, consultate su 토지이음 il 2026-09-28)

| Campo | Riga 1 — storico avvisi | Riga 2 — zone d'uso |
|---|---|---|
| item | Storico avvisi del piano di gestione su 안서동 300 — vigente 천안시 고시 제2023-216호 (decisione + tavola topografica 2023-08-01, efficace dal 2023-08-01) | Zone d'uso sul lotto 안서동 300 — prevalente 자연녹지지역, poi 보전녹지지역 e 제2종일반주거지역 |
| value | `16` | `3` |
| unit | avvisi distinti 1986→2023 | zone d'uso |
| source | 토지이음, 도시계획 열람 → 관련 고시 정보 (eum.go.kr/web/cp/cv/cvUpisDet.jsp) · 천안시 고시 제2023-216호 | 토지이음, 토지이용계획열람 → 지역지구등 지정여부 (eum.go.kr/web/ar/lu/luLandDet.jsp) |
| queried_on | `2026-09-28` | `2026-09-28` |

Perché questi numeri: `value` è numeric, quindi una data o un nome di zona non ci stanno (il nome di zona è
scala nominale). Si salva ciò che è contabile, cioè il numero di avvisi nella catena storica e il numero di zone
sul lotto; date e nomi restano leggibili in `item`.

## Log di verifica (da compilare)

- **Persistenza** — righe id 1 e 2 salvate dal modulo il 2026-09-28 07:33 UTC: presenti dopo il ricaricamento ☑ · in un altro browser (Edge con profilo nuovo, Chrome) ☑ · in Table Editor ☑ · su un altro dispositivo (smartphone, pagina pubblicata, 2026-09-28) ☑ · nel browser di 전세진 (pagina pubblicata, 2026-09-28) ☑
- **Chiavi** — ricerca di `sb_secret_|service_role|eyJ…` nei file della cartella → nessuna chiave ☑ (2026-09-28). Ripetere dopo il commit: `git grep -nE "sb_secret_|service_role" HEAD`

## PDF di consegna

`consegna/build_pdf.py` genera `consegna-extra-LUOGO.ko.pdf` e `.it.pdf` (1 pagina). Dopo il deploy compilare
`DEPLOY_URL`, `OTHER_DEVICE`, `CLASSMATE` in cima allo script, salvare lo screenshot di Table Editor come
`screenshots/table-editor.png` e rilanciare `python build_pdf.py`.

## Indirizzi

| | |
|---|---|
| Deploy | https://elisacantalini.github.io/luogo-smartcity/ |
| Repository | https://github.com/elisacantalini/luogo-smartcity |
