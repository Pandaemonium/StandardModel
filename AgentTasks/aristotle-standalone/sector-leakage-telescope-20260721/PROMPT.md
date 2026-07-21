# Aristotle target: quantitative sector-leakage telescope

Prove every theorem in `SectorLeakageTelescope.lean` under the exact displayed
hypotheses. Run `lake env lean SectorLeakageTelescope.lean` first.

The intended proof ladder is:

1. inductive noncommutative commutator telescope;
2. triangle/submultiplicativity bound for contractions;
3. exact idempotent-projector leakage identity;
4. changing-regulator squeeze theorem; and
5. exponential suppression beats linear depth.

Preserve the generic `NormedRing` setting. Do not silently assume a C-star
algebra, self-adjointness, or unitarity: contraction and normalized idempotent
are the intentionally weaker hypotheses. Do not add assumptions, axioms,
opaque definitions, unsafe code, native_decide, admit, or leave sorry. Small
helper lemmas are welcome. Finish with a concise report of any statement repair
that was mathematically necessary.
