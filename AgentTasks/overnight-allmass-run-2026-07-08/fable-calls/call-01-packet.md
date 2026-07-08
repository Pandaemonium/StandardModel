# Fable-5 call 01: all-mass manuscript audit + hardest-crux advance

You are the most capable theorist on this formalization program. This call
has two parts; spend most of your effort on Part B (advancing the program),
per the standing instruction that a Fable call should ADVANCE, not merely
validate. You have read-only access to the repository, the literature
graph, and Mathlib/PhysLean — use them.

## Context (standalone)

This is a Lean 4 program formalizing the thesis **"mass is the obstruction
to coherent null transport."** The trusted core is kernel-checked:
`det P = sum_{i<j} |psi_i wedge psi_j|^2` (mass² = pairwise null-direction
disagreement). A finite carrier Dirac operator `D = sum_e c(alpha_e)
nabla_e + Gamma phi` squares to four channels: aperture `Q_A` (kinetic),
closure `Q_C` (gauge/QCD), turn `Q_T` (Higgs), soldering-gradient `E`
(gravity). "Unification is decomposition." `#` is a Krein adjoint (the
geometry is indefinite by construction).

Fuller standalone context is in
`AgentTasks/overnight-allmass-run-2026-07-08/COLLABORATOR_BRIEF_2026-07-08.md`
(read it) and the QCD roadmap
`Sources/Null_Edge_QCD_Mass_Roadmap_2026-07-07.md` (Amendments A, B).
Tonight's new kernel landings: chiral determinant dichotomy
(`ChiralZeroModeParity.lean`), finite Banks-Casher count
(`FiniteBanksCasherCount.lean`), signed mass-budget theorem + witness
(`CarrierMassBudget.lean`), plus the S1 closure-square algebra
(`S1ClosureCurrentAlgebra.lean`).

## Part A: manuscript audit (be ruthless)

The manuscript under review is
`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` (provided verbatim
as a source file). Audit it against the four over-claim modes:
(1) vacuity, (2) hollow telescoping, (3) docstring/prose outruns kernel,
(4) false shape (a kernel statement that is not the intended mathematics).
For EACH section, either certify it honest or name the exact sentence that
over-claims and the minimal fix. Check specifically: is any share called
"positive" that is only "signed"? Is the chromomagnetic-vs-energy
distinction (`Q_C` linear in F, defect Gram `|F|^2`) held everywhere? Are
the reported kills (Koide, Tr E, defect-Gram, cyclic-symmetry) stated at
theorem prominence? Flag anything that reads as elegance bought with
imprecision. Also: suggest the single highest-leverage improvement to
CLARITY and ELEGANCE of exposition.

## Part B: advance the hardest open crux (the main ask)

Pick the one where you can make the most real progress and GO DEEP. In
rough priority:

1. **S1-CC (the central positivity crux).** `Q_C = L^# L` is an exact
   Krein square (any compact group) with a GL-torsor of representatives;
   because every representative squares to the same `Q_C`, physical-sector
   positivity reduces to the inertia of `Q_C` restricted to the Gauss-law
   sector `V'/N`. The blocker is a principled construction/transcription of
   `V'` on the concrete finite carrier and the descent conditions
   (`Q_C V' subseteq V'`, `Q_C N subseteq (V')^perp`). Can you (a) give the
   right finite definition of `V'` from the carrier Gauss/closure covectors,
   (b) settle the descent conditions abstractly, and (c) predict the
   restricted inertia — i.e. is closure positive on the physical sector, or
   is it honestly signed (in which case state the exact trade-off with the
   total-operator positivity)? A sharp no-go is as valuable as a yes.

2. **The multi-direction closure square (C3).** Two-direction
   `Q_C = L^#L` is proved; for d>=3, `Q_C = -sum_{mu<nu} b_{mu nu}
   [nabla_mu, nabla_nu]` and a pair-indexed direct-sum current gives an
   exact square by stabilization. Is the SINGLE (unstabilized) current
   ever possible, or is there a clean rank/signature no-go forcing an
   aperture-shaped correction? State the invariant that decides it.

3. **The chiral winding invariant (C4/§8).** A unitary transfer `W` with a
   chiral involution `Gamma` (`Gamma W Gamma = W^dagger` = edge-reversal
   grading) has `det W = +-1` (kernel-checked). Empirically the even-V
   half-winding (alternating-phase) decoration pins BOTH +1 and -1
   eigenvalues for every hop amplitude, at even dimension where parity
   alone does not force it. What is the correct finite invariant (a chiral
   winding number, a la Asboth-Obuse 0/pi-mode indices, arXiv:1303.1199)
   that forces the double pinning, stated so it is Lean-formalizable?

For whichever you choose: give the precise theorem statement(s), the proof
strategy or the no-go, the exact Mathlib API where relevant, and a
pre-registered kill condition. Assume we will formalize your answer.

## Output format

- Part A: a per-section verdict table + the one clarity/elegance
  recommendation.
- Part B: the chosen crux, the theorem statement(s), the
  strategy-or-no-go, and the kill condition.
- Grade every claim you make (T / M-target / MEMO / C).
