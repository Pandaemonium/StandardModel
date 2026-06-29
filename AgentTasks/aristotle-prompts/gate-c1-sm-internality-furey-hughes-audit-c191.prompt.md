Project name: gate-c1-sm-internality-furey-hughes-audit-c191

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C177 proves gauge safety if SMActsInternally holds: SM generators act as id_Branch tensor g_i and branch/CKM mass acts on the branch/flavor factor tensor internal identity. We still need to audit the actual intended Furey/Hughes/SM embedding.

Task:
Design a concrete SMActsInternally audit for the Furey/Hughes-inspired internal sector plus null-edge branch/CKM texture.

Requested output:
1. Identify exactly what factor carries the null-edge branch grading J and CKM texture.
2. Identify what factors SM gauge generators act on in the Furey/Hughes-style construction.
3. State the factorization conditions needed for every generator to be id_Branch tensor g_i.
4. List red flags where weak chirality, hypercharge, generation/flavor, or octonion ladder operations might accidentally mix the branch factor.
5. Give a Lean/API certificate structure for `SMActsInternally` specialized to branch x flavor x internal representation.
6. If the audit cannot be completed without convention choices, list the exact convention choices needed.

Do not assume the physical embedding passes. This is an audit/no-go job.
