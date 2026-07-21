# Lemma job: the mixed / pseudo-Dirac neutrino branch (fills the A5 gap)

Mathlib-only. The A5 four-branch classification was audited as NOT exhaustive: the
MIXED branch (simultaneous Dirac + Majorana mass) was missing. Close it. Model a
neutrino sector `nu_L, nu_R` with BOTH a Dirac mass `mD` and a right Majorana mass
`MR` AND a left Majorana mass `ML`, giving the symmetric mass matrix
`M = [[ML, mD],[mD, MR]]` (complex symmetric, on nu_L (+) nu_R). Prove:
1. this genuinely GENERALIZES both the pure-Dirac (`ML=MR=0`) and pure-Majorana
   (`mD=0`) branches - each is a special case;
2. the PSEUDO-DIRAC limit: when `ML, MR -> 0` (small Majorana masses) with `mD`
   fixed, the two mass eigenvalues are `mD +- (ML+MR)/2`-ish (a nearly-degenerate
   pair split by the small Majorana terms) - compute the exact `2x2` symmetric
   eigenvalues and the small-splitting expansion;
3. the branch is distinct from all four principal branches: exhibit parameters
   where `M` is neither pure Dirac (off-diagonal only) nor pure Majorana (its
   Dirac part `mD != 0` AND a Majorana part `ML or MR != 0`);
4. lepton number is violated (the Majorana parts) yet a Dirac limit exists -
   state the interpolation.
This closes the missing A5 row. Explicit `2x2` complex-symmetric algebra; no new
axioms/native_decide; standard axioms; report axioms.
