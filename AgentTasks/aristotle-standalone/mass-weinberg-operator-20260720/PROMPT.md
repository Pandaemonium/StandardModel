# Lemma job: explicit Weinberg dimension-5 operator -> Majorana mass (A5)

Mathlib-only. Concrete construction behind the A5 Weinberg branch (Weinberg 1979).
Model the lepton doublet `L : Fin 2 -> C` and Higgs doublet `H : Fin 2 -> C` and
the dimension-5 operator contraction `O5(L,H) = (Lᵀ eps H)(Lᵀ eps H)` where
`eps = [[0,1],[-1,0]]` is the SU(2) antisymmetric tensor. Prove:
1. `O5` is SU(2)-invariant: for `U` in SU(2) (unitary, det 1),
   `O5(U L, U H) = O5(L, H)` (uses `Uᵀ eps U = eps` for det-1 U);
2. after electroweak breaking `H -> (0, v)`, `O5` reduces to
   `v² (L 0)²`, i.e. a Majorana mass `~ v²/Lambda` for the neutrino component
   `L 0` - exhibit the exact coefficient;
3. the operator violates lepton number by two units: under `L -> exp(I a) L`,
   `O5 -> exp(4 I a) O5` (not invariant, unlike a Dirac bilinear which is
   invariant) - the Delta L = 2 signature.
This is the explicit effective-operator origin of the Majorana branch. Explicit
small objects; no new axioms/native_decide; standard axioms; report axioms.
