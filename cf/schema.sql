-- i2i-ledger — D1 schema (R1)
-- The ledger is append-only in spirit: never delete; supersede by booking a
-- new entry that names the old one (see ../AGENTS.md).

CREATE TABLE IF NOT EXISTS ledger (
  id          TEXT PRIMARY KEY,           -- same id used as the Vectorize vector id
  agent       TEXT NOT NULL,              -- booking agent name, e.g. 'lucineer'
  gist        TEXT NOT NULL,              -- one-line gist (### heading text)
  body        TEXT,                       -- bullets: learned · receipt · books-to
  receipt_url TEXT,                       -- link to the receipt (repo/commit/path)
  books_to    TEXT,                       -- lanes/repos/ideas this entry books to
  ts          INTEGER NOT NULL,           -- booking time, epoch seconds
  embedded    INTEGER NOT NULL DEFAULT 0, -- 1 once the vector is upserted
  created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_ledger_ts ON ledger (ts);
