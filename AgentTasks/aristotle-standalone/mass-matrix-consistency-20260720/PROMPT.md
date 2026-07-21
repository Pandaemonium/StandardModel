# Audit job: cross-consistency of the origin-of-mass mechanism response classes

Mathlib-only analysis + lemmas. The Opus mass program landed response operators in
distinct classes on a graded space `V = V_L ⊕ V_R` (chirality `Γ`): fermion turn
(Γ-odd off-diagonal), gauge Gram + Higgs Hessian (Γ-even PSD), neutrino (Γ-odd or
Majorana-symmetric), composite transfer (PSD). Prove the mechanism matrix is
INTERNALLY CONSISTENT (no two rows secretly force the same operator to be both a
nonzero Γ-odd block AND a Γ-even block):
1. an operator that is simultaneously Γ-odd and Γ-even is zero (`{A : ΓA=-AΓ ∧ ΓA=AΓ} = {0}`);
2. therefore the fermion-mass row and the gauge/Higgs rows are realized by
   operators in a direct-sum decomposition (Γ-odd ⊕ Γ-even), and a nonzero mass in
   one row does not imply a nonzero contribution in the other;
3. state the one shared datum (the vacuum/grading) that all rows legitimately
   depend on, distinguishing legitimate shared-input from illegitimate
   double-counting.
Concrete small `V` acceptable. No new axioms/native_decide; standard axioms;
report axioms.
