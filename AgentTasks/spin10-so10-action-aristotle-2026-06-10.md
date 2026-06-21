# Aristotle task: infinitesimal Spin(10) action on the Fock model

Date: 2026-06-10

## Goal

Fill the four documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldSO10ActionAristotle.lean
```

establishing the infinitesimal `so(10)` action on the Fock spinor model:

```lean
rho_intertwine                 -- [rho(v^w), gamma_u] = gamma_{ad(v^w)u}
rho_bracket                    -- rho is a Lie algebra representation
chevalleyPairing_rho_skew      -- pairing infinitesimally invariant
gammaBilinear_rho_equivariant  -- q intertwines spinor and vector actions
```

The derived consequence `purity_infinitesimally_invariant` (the purity
quadric is tangentially preserved) is already proved in the draft modulo the
targets, as are the easy structure lemmas (`rho_self`, `rho_antisymm`,
`isEvenSpinor_rho`, `B10_soAd_skew`).

## Mathematical intent

This is the entry point to the group-level part of the
`Sources/Spin10_stabilizer.txt` program: orbits of pure-spinor pairs and the
`S(U(2) x U(3))` Selector Theorem all rest on the equivariance of the
gamma-bilinear under the spin action. The four targets are the standard
structure facts of the spin representation, stated concretely on the
trusted Fock model.

## Oracle

All four statements are verified with exact rational arithmetic by

```bash
python Scripts/oracle/validate_spinor_tenfold.py   # test section [so10]
```

in the same sign conventions. Use it only as sign guidance.

## Proof guidance

- Targets 1 and 2 should be formal consequences of the trusted CAR layer:
  `cliffordAction_anticomm` (`gamma_v gamma_w + gamma_w gamma_v = B10 v w
  smul id`) in `PhysicsSM/Spinor/SpinorTenfoldCAR.lean`, plus bilinearity
  (`cliffordAction_add_vec`, `cliffordAction_smul_vec`,
  `cliffordAction_add_spinor`, `cliffordAction_smul_spinor`).
- For target 3, first prove the (anti-)self-adjointness of a single Clifford
  operator for the Chevalley pairing, e.g. `chevalleyPairing
  (cliffordAction u psi) phi = chevalleyPairing psi (cliffordAction u phi)`
  (derive the correct sign from the alpha-twist convention; the oracle
  confirms the final statement), then target 3 follows formally. A
  basis-level finite check transported through the integer mirror of
  `PhysicsSM/Spinor/SpinorTenfoldGammaSymm.lean` (as done for
  `gammaBilinear_symm`) is an acceptable alternative; prefer plain kernel
  `decide` over small data if enumeration is needed. No `native_decide`.
- Target 4 follows from target 3 via the adjunction `B10_gammaBilinear`
  (`B10 (gammaBilinear psi phi) v = chevalleyPairing (cliffordAction v psi)
  phi`) together with nondegeneracy of `B10` (which may need a small helper:
  vectors agreeing against all `v` under `B10` are equal — provable
  componentwise by testing against basis vectors).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change `rho`, `soAd`, or any trusted definition or sign convention.
- Do not weaken the theorem statements. Helper lemmas are welcome.

## Verification

```bash
lake build PhysicsSM.Draft.SpinorTenfoldSO10ActionAristotle
```

## Submission

Status: re-submitted 2026-06-11, third attempt (previous attempts failed with internal server errors/timeouts; third attempt submitted after replacing decide with sorry in submission-only FierzKernel.lean).

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave4-20260610
```

aristotle:
  job_id: 4a36a5c3-6ecc-426a-a0aa-7f67b5234a4f
  target_file: PhysicsSM/Draft/SpinorTenfoldSO10ActionAristotle.lean
  expected_module: PhysicsSM.Draft.SpinorTenfoldSO10ActionAristotle
  submission_project: AgentTasks/aristotle-submit/spin10-wave4-20260610
  output_dir: AgentTasks/aristotle-output/4a36a5c3-6ecc-426a-a0aa-7f67b5234a4f
  status: integrated


Previous jobs (failed/cancelled, internal server error):

```text
24ffa840-9b51-46d5-b746-37224b507318
d5acb603-2982-4b3d-adf1-8bdc934c4e7b
```
