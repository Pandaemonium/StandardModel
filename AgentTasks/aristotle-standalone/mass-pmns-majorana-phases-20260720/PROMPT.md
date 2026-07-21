# Lemma job: PMNS Majorana-phase parameter structure (A5 mixing capstone)

Mathlib-only. Complement to the CKM Jarlskog job, for the LEPTON sector. The
neutrino classification counted a Majorana extension as +2 Majorana phases beyond
the Dirac count. Formalize why Majorana phases are physical (not rephasable away):
1. for a Majorana mass matrix `M` (complex SYMMETRIC, `Mᵀ = M`), the allowed field
   redefinition is `M -> Uᵀ M U` for unitary `U` (congruence, NOT similarity),
   because the Majorana bilinear is `ψᵀ C M ψ`;
2. prove that a diagonal rephasing `U = diag(exp(I a_i))` acts on `M` by
   `M i j -> exp(I(a_i + a_j)) M i j` (phases ADD, unlike the Dirac case where they
   subtract), so a diagonal real `M` cannot have all its phases removed by
   rephasing when off-diagonal - exhibit a 2x2 symmetric witness whose relative
   phase is rephasing-invariant;
3. contrast: a Dirac mass `M -> Vₗ† M Vᵣ` (similarity by two unitaries) CAN remove
   more phases - state the count difference (the extra Majorana phases).
This is the concrete structure behind "Majorana branch costs +2 phases". Explicit
small matrices; no new axioms/native_decide; standard axioms; report axioms.
