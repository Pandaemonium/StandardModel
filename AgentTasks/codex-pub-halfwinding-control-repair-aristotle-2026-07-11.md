# Aristotle proof job: repair the explicit half-winding controls

Name this project `codex-pub-halfwinding-control-repair-20260711`.

Prove all seven theorems in `HalfWindingControlRepair/Main.lean` with statements
and constants unchanged. Run the narrow target first. The source module is
provided verbatim and already compiles.

Scientific purpose: an adversarial audit found that the existing zero/four
control determinants were stated only for displayed compressed matrices and
were never connected to the full control walks. Exact independent computation
establishes the four intertwiners/determinants requested here, with
`det(Wzero +/- I) = det(Wfour +/- I) = 1296/625`. The two-wall characteristic
polynomial factors as displayed, giving algebraic multiplicity two at both
`+1` and `-1` without claiming localization or perturbative protection.

You may add small helper lemmas or explicit matrix-value lemmas. Do not change
the walks, the controls, the compression, the determinant value, or the
factorization. Do not replace a full-walk determinant theorem by another
compressed-block theorem. Prefer kernel-checkable `norm_num`/finite matrix
proofs; if the only practical proof uses compiler-trusting finite evaluation,
make that trust footprint explicit and return it honestly.

If any statement is false, return the exact countervalue and stop rather than
weakening it.

Oracle provenance: SymPy 1.14.0, exact `Rational` arithmetic, with basis order
`[(x,h) for x in range(4) for h in range(2)]`; the script reconstructed
`shiftQ`, `coinQ`, and `walkQ = shiftQ * coinQ * shiftQ` directly from the Lean
definitions and evaluated all four full-walk determinants and the exact
eigenvalue multiplicities. This oracle selects fixtures only and is not a
proof; the Lean target is the required certificate.

```yaml
aristotle:
  project_id: d9d46738-f7ea-44b7-a73b-5f9a12f4e3e2
  target_file: HalfWindingControlRepair/Main.lean
  expected_module: HalfWindingControlRepair.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-halfwinding-control-repair-20260711-project
  output_dir: AgentTasks/aristotle-output/d9d46738-f7ea-44b7-a73b-5f9a12f4e3e2
  status: harvested-preserved-not-integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Local repair while remote build continued

The remote snapshot proved all seven submitted statements but its direct
8-by-8 determinant evaluation exceeded the local Windows interpreter depth.
Rather than claim an unverified local integration, the live repository now
uses stronger explicit rational left-inverse certificates in
`PhysicsSM/Draft/NullEdge/HalfWindingFullWalkControls.lean`. They prove directly
that the complete zero-wall and four-wall fixtures have no nonzero eigenvector
at either sign. Direct Lean and targeted module build both pass locally. The
remote determinant and characteristic-polynomial factorization remain
unintegrated until their verification path is locally robust.

## Final harvest

The remote task completed with all seven statements unchanged. Its final
summary and source are preserved under
`AgentTasks/aristotle-output/d9d46738-f7ea-44b7-a73b-5f9a12f4e3e2/result/`.
The result uses compiler-trusting finite evaluation for the determinant
certificates and a structural eight-point argument for the characteristic
polynomial. The submitted file is intentionally not copied into the live tree:
the direct determinant path exceeded the local Windows interpreter depth, while
the landed left-inverse certificates prove the publication-critical zero/four
no-mode controls more directly and build locally.
