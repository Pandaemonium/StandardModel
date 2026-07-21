# Lemma job: a concrete finite reflection-positive transfer sector with a nontrivial gap (A3)

Mathlib-only. Construct a SMALL explicit reflection-positive (symmetric
positive-definite) transfer matrix `T` modeling a gauge-invariant sector, with:
1. a nondegenerate top eigenvalue (vacuum) and a strictly smaller second
   eigenvalue (a nontrivial "glueball-like" gapped excitation);
2. a gauge-invariant observable `O` (a vector) with NONZERO overlap on the first
   excited state, so the connected correlation `⟨O,Tⁿ O⟩_c` decays at exactly the
   gap rate (the composite mass);
3. a control observable `O'` overlapping only the vacuum, whose connected
   correlation is identically zero (no composite excitation seen).
Prove the gap is strictly positive and the two correlation behaviors differ. This
is the concrete "nontrivial finite sector" + "constituent-vs-binding" control the
A3 bridge needs. Explicit small matrices; no new axioms/native_decide; standard
axioms; report axioms.
