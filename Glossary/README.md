# Physics and Math Glossary

The glossary's editable source is the JSONL in `terms/`. Its schema is
`term.schema.json`; its design and agent workflow are documented in
[`../docs/GLOSSARY.md`](../docs/GLOSSARY.md).

From the repository root:

```powershell
python Scripts/glossary/validate.py
python Scripts/glossary/build.py
python Scripts/glossary/query.py clifford-algebra
python -m http.server 8000
```

After starting the server, open
`http://localhost:8000/Index/glossary/site/`.

Do not edit `Index/glossary/` by hand. It is deterministic generated output.
