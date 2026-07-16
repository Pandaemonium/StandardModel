# Aristotle standing target queue

Purpose: keep the fleet full (target 8 active). On every harvest, pull the next
ready target and fire it. Both interactive families draw from and add to this
queue. A target is "ready" when a standalone Lean file typechecks with the hole
and a route note. Record project IDs in `ARISTOTLE_JOBS.json` immediately.

Status legend: FIRED (project id) | READY (typechecks, not yet fired) |
PREP (needs a standalone package) | BLOCKED (depends on another).

## In flight (as of 2026-07-13 ~09:25)

- FIRED `e4fb5dcd` - **universal 3+1 Brillouin degree balance**: close
  `admissible_doubling` by constructing the canonical integer chirality/degree,
  proving torus balance and nonzero origin charge, or return a counterexample or
  the minimal missing hypotheses without weakening the admissible-walk API.
- FIRED `799b9218` - **noncommuting Gibbs variational uniqueness**: turn the
  general quantum Klein inequality and equality case into an exact free-energy
  identity, nonnegativity theorem, equality iff, and strict uniqueness result.
- FIRED `80dae4ce` - **general Sn selector classification and phase diagram**:
  generalize the two-parameter fixed-total classification to arbitrary finite
  channel types, including empty/singleton controls and all three transverse
  regimes; attempt the full permutation-invariant coefficient theorem.
- FIRED `d5df5530` - **compact-support L2 generator**: prove that compact
  momentum support places the multiplier generator in `L2` and gives the exact
  strong derivative at zero, without promoting it to a bounded generator.
- FIRED `d2d33e0e` - **finite-depth null-microstep / longer-effective-range
  construction**: preserve null nearest-neighbor support at every primitive
  substep while generating mixed-axis or degree-two Laurent words over a full
  period. It must instantiate the repaired admissible-walk gate and classify
  both zero and pi crossings; extra range may relocate rather than remove the
  partner.
- FIRED `cdcc00ba` - **pi-flux 3+1 construction and full zero/pi census**:
  extend the exact position-dependent magnetic-translation seed to the
  smallest three-dimensional twisted walk, derive its reduced-zone Floquet
  symbol, and classify every zero and pi quasienergy crossing. A partner moved
  to pi or hidden by zone folding is an explicit failure condition.
- FIRED `180406b2` - **all-time position-space Dirac PDE audit/design**: return
  the strongest correct Schwartz or graph-domain differentiability theorem,
  preserving Fourier normalization and domain distinctions.
- FIRED `2963f848` - **genuine pinching-channel DPI design**: produce a
  typechecking theorem ladder for quantum relative entropy under an explicit
  nontrivial pinching channel, not a relabelled classical measurement theorem.

## Ready successors

- FIRED `5ed47bad` - **signed flavor-cover Clifford decoder**: prove that the unsigned
  `Z2^3` deck flips commute while their fermionically signed lifts form the
  three-generator Clifford action, with explicit sign and unsigned negative
  controls. Package:
  `AgentTasks/aristotle-submit/afpl-clifford-cover-decoder-20260713-project`.
  This is DK0 for the exterior/Dirac-Kahler local-decoder route; it does not
  yet prove that a nontrivial onsite projector commutes with the physical QCA.
- READY - **qubitized Wilson crossing core**: prove the exact shifted
  qubitization determinant law and compose it with the unique Wilson spatial
  zero. Package:
  `AgentTasks/aristotle-submit/afpl-qubitized-wilson-crossing-20260713-project`.
  This is now a simulation/obstruction control, not a claimed chirality or
  fermion-doubling escape; the colocated zero/pi partner remains explicit.
## Harvested strategy results awaiting full disposition

- INTEGRATED `550cdd51` - exact two-dimensional pi-flux cocycle seed. Local
  replay and independent Claude semantic review passed: the position-dependent
  magnetic translations anticommute, are bijective, and cannot be replaced by
  a commuting global-sign pair. This seed alone is not a 3+1 decoder; successor
  `cdcc00ba` owns the compatible-decoder and full zero/pi census gates.

- INTEGRATED `5ed47bad` - signed Clifford flavor-cover core. The
  returned target proves commuting unsigned deck flips versus anticommuting
  Jordan-Wigner signed flips, exact involutions, and a nondegenerate occupied-
  mode witness. It correctly reports the originally requested vacuum witness
  false and proves equality on vacuum instead. No particle or doubler-removal
  claim is authorized.

- REVIEW PENDING `bafdd210` - strict local 3+1 frontier. The returned module
  proves determinant-level corner/body-center crossings, a nonvacuous scoped
  factorized no-go, and an admissible-walk interface. The universal
  `admissible_doubling` theorem remains the only documented proof hole and has
  been resubmitted as focused successor `e4fb5dcd`.

- INTEGRATED `7f0c4cea` - exact pointwise Schwartz-generator/PDE capstone.
  The returned pointwise and Fourier-conjugation theorems are reported complete
  and guard-pinned; differentiation in the full Schwartz topology remains an
  explicit missing Frechet-calculus/API gate rather than a weakened theorem.

- INTEGRATED `686f31b0` - the information-natural selector classification
  has been downloaded and scanned placeholder-clean. Its proposed conclusion
  is deliberately negative/conditional: entropy or KL selects equal thirds
  only relative to a named uniform prior; symmetry plus uniqueness selects the
  barycenter, while a skew prior gives a distinct nondegenerate selector.
  Independent Claude semantic review accepted the conditional/negative scope.

- INTEGRATED `52a3a73b` - exact QCA-cover/octet bridge. The regular `Z2^3`
  torsor, `Fin 8` octonion XOR equivalence, multiplication-support law, and
  noncanonicity witness are guard-pinned. The bridge carries no charge, color,
  chirality, generation, particle identity, or QCA dynamics.

- INTEGRATED `81bc8433` - the S3 selector phase diagram proves unique
  equal-thirds selection, a flat fixed-total fibre, or unbounded-below
  instability according to the sign of the transverse coefficient. It passed
  local replay, cross-family review, and the aggregate axiom-guard build.

- INTEGRATED `b064c004` - the exact position Dirac expression is packaged as a
  continuous linear endomorphism of four-component Schwartz space, agrees
  pointwise with the audited raw operator, and has the exact affine Dirac
  Fourier symbol. This is a Schwartz operator theorem, not yet differentiability
  of the time group or a changing-lattice PDE limit.

- INTEGRATED `293198fd` - general finite-dimensional quantum relative entropy
  vanishes exactly when the two admissible density matrices agree, with strict
  positivity for unequal states. The reconstruction allows arbitrary unitary
  mixing inside degenerate eigenspaces and does not assume commuting matrices
  or a permutation overlap.

- INTEGRATED `909624b6` - full S3-invariant quadratic selector classification:
  the six coefficients reduce to two, one common-mode term is constant on each
  fixed-total fibre, and positive transverse coefficient gives the unique
  equal-thirds selector. Physics and information theory have not yet selected
  a preferred coefficient.

- INTEGRATED `65c69022` - arbitrary-phase operator S2 capstone, including
  entropy, Gibbs, normalized-energy, modular-flow, and strict-equality
  covariance. The result is phase-covariant; it does not by itself make a
  constant single-site phase observable.

- INTEGRATED `06176494` - exact Dirac multiplier temperate growth. The server
  job became non-cancellable after the stall limit, but its preserved snapshot
  contained a complete theorem that replayed locally under Lean 4.28, passed an
  adversarial cross-family review, and is guard-pinned in
  `ChangingCellFourierTemperate`. It proves the full-momentum temperate-growth
  hypothesis needed for Schwartz multiplication, not Schwartz closure or a
  position-space PDE by itself.

- INTEGRATED `0ab450fa` - finite-volume mixed-Poisson configuration-law
  invariance. The returned theorem replayed locally, passed the aggregate guard,
  and received cross-family semantic acceptance. It proves invariance in law
  under a position-law-preserving map, not pointwise fixed configurations,
  infinite-volume existence, or Lorentz invariance.

- INTEGRATED `c2da9ae1` - pointwise exact-flow generator. Both immutable
  derivative theorems are live and guard-pinned after local Lean 4.28 replay
  and Claude-family semantic acceptance. The generator is exactly
  `-i H(k,m)` with right-multiplication orientation. Full-`L2` domains,
  Fourier transport, and the position-space PDE remain separate.

- INTEGRATED `844d7dcd` - strong time continuity of the exact momentum-space
  `L2` orbit. Fibre and quotient-safe zero-time identities, dominated-
  convergence continuity for every fixed state, and nonzero rest-orbit control
  are live and guard-pinned. This is not operator-norm continuity and does not
  yet identify the unbounded generator or position-space PDE.

- INTEGRATED `f3898781` - phase-covariant modular selection. The exact
  phase-gauge, Gibbs-state, modular-flow, normalized-observable, relative-phase,
  and zero-boundary ladder replayed successfully and is now in the live draft
  tree with aggregate guards. Cross-family audit `msg-20260713-031429-c07cb08a`
  accepted the orientation, scale factors, boundaries, and the wording that
  distinguishes invariant relative-phase data from the separate operational
  `Uop` witness.

- HARVESTED `70a0d064` - rooted-touch normalization bridge R0. Immutable
  theorem returned placeholder-free and replayed successfully; handed to the
  Claude-owned Yang-Mills work item for guarded integration. The returned
  aggregate guard is stale and must not be copied. R1 is not authorized
  automatically.
- HARVESTED `1babf8da` - grand strategy: elevates the continuum commuting
  square and constructive gauge spine; identifies supplied-dynamics,
  cosmological-count, and octonion-multiplicity inputs; proposes a cheap
  gap-variance falsifier.
- HARVESTED `5d4f2be5` - continuum F2/F3 architecture: exact representative-safe
  Fourier-to-PDE ladder; Mathlib's raw Fourier coordinate forces the displayed
  `-i/(2*pi)` spatial coefficient.
- HARVESTED `535c94a2` - Yang-Mills EGF audit: exact rational counterexample
  kills `pairSum_le_expBound` and its unrooted recurrence route. The corrected
  route uses rooted child sums; `70a0d064` is its first proof rung.
- DEFERRED `46a2e213` - arbitrary-density qubit max-entropy wrapper. Canceled
  after full external reconciliation revealed it as the hidden eighth live job;
  this non-gating wrapper yielded its slot to the higher-priority F3
  temperate-growth theorem. Preserve any partial output for a scoped retry.
- CANCELLED `3f23d59b` - A/E bridge classification. A snapshot preserves the
  typechecking skeleton, but no proof was discharged after four hours and the
  work item was already parked by the invariant-hollowness audit. Do not revive
  without a genuinely nontrivial graded/star-algebra invariant.
- CANCELLED `3b1fe9d3` - broad Fourier partial-derivative package. Its immutable
  theorem statement was preserved and resubmitted as focused job `7be67a65`.
- CANCELLED `28e4ff06` - broad Poisson distributional-strategy package. Its API
  audit and statement skeleton were preserved; the positive law theorem and
  negative decoration control were split into `0ab450fa` and `ac97f093`.

## Landed + banked this push (kernel-clean, guard-pinned)

DPI `74503dba`, Gibbs `6bb9f7bb`, S1 matrix-Euler `0bf55f18`, max-entropy
`273a28be`, SSA `f52514f3` (+controls `92ee3e9e`), Pinsker `9cc68db9`, PSD-trace
`5edc72d8`, HS-CS `5c6b4653`, vonNeumann `8300c085`, purity `d8ca01fc`, and the
general noncommuting quantum Klein inequality `c35c62e5`. See
`AutonomousLab/work/NE-RESOURCE/CLAUDE_INFO_THEORY_FOUNDATION_2026-07-12.md` for
the coherent map. The finite entropy/nonnegativity foundation is now broad;
quantum-channel data processing and equality conditions remain separate gates.
The exact pointwise Dirac multiplier isometry `e790e78a`, the generic
representative-safe `L2` lift `1271173b`, and the locally proved live
continuity/measurability specialization are now landed in
`ChangingCellFourierPDE`, with standard kernel footprints. The resulting
`momMultL2Isometry` is an exact norm-preserving momentum-space `L2` operator;
its time-group, Fourier, generator, and PDE successors remain separate.
The generic lift now also has the reviewed composition theorem `63e6b14f` and
identity/double-negative controls. The reference-eigenbasis
projective-measurement DPI `1493c36f` is landed and guard-pinned; it is not a
general CPTP theorem and carries no concrete strict noncommuting qubit witness.

## Ready / next to fire (highest value first)

- FIRED `550cdd51` **position-dependent pi-flux decoder seed** - target and
  task note at `AgentTasks/pi-flux-cocycle-decoder-aristotle-2026-07-13.md`.

- **TECHNIQUE UNBLOCK (2026-07-12): CFC-free matrix functional calculus.**
  `Matrix.log` does NOT exist in v4.28 and CFC hits `NormedRing (Matrix n n C)`
  friction, BUT `Matrix.IsHermitian.spectral_theorem` + `eigenvectorUnitary` +
  `eigenvalues` let you DEFINE any matrix function by construction on the
  eigenbasis (`f(rho) := V * diagonal (f o eigenvalues) * V^H`) and it
  typechecks. General Klein `c35c62e5` shows that a two-basis unistochastic
  reduction can sometimes avoid operator convexity entirely.
- PREP **quantum data-processing inequality under a sharply scoped channel** -
  first try a pinching or partial-trace class with explicit Kraus data; do not
  call Klein nonnegativity itself data processing.
- FIRED `be3e675b` **scalar Klein equality condition** - prove the strict
  doubly-stochastic overlap core first; the general matrix equality wrapper is
  deferred until this exact bottleneck lands.
- FIRED `65c69022` **arbitrary-phase operator S2 capstone** - compose the
  harvested phase covariance with the strict full-Bloch max-entropy theorem;
  keep constant phase as basis covariance and all supplied inputs explicit.
- FIRED `c8b815ee` / `debcfc09` **continuum F3 Schwartz composition** - the
  exact multiplier-isometry and Fourier derivative inputs are landed; preserve
  the `2*pi` normalization and do not promote these domain theorems to a
  changing-lattice PDE limit.
- BLOCKED **rooted EGF recurrence R1** - waits on `70a0d064`; use canonical
  rooted children and a global exponential formula, never a fibrewise bound.
- PREP **matrix SSA (Lieb)** / **Peierls-Bogoliubov** - thermal/free-energy layer
  above Golden-Thompson; general noncommuting statements remain hard even
  though Klein is now landed.
- PREP **entropic uncertainty (Maassen-Uffink, finite)** - `H(|psi|^2) +
  H(|U psi|^2) >= -2 log max|U_ij|`; complementarity direction, needs interpolation.
- NOTE most earlier PREP items are DONE: S1 Fock-level exponential, S2 qubit
  max-entropy, GateC2 covariance audit, finite-support Lorentz no-go, and the
  general Klein inequality. Do not duplicate them.

## Adding a target

1. Write a standalone `AgentTasks/aristotle-standalone/<job>/<Module>.lean` with
   the definitions + statement + a documented `s o r r y` + a route note.
2. `lake env lean` it (must typecheck with only the `s o r r y` warning).
3. `pwsh Scripts/prepare_aristotle_focused_submission.ps1 -JobName ... -RootModule ... -LeanPath ... -SourceRoot ...`
4. `aristotle submit --project-dir <prepared> "<focused prompt: prove the hole, run lake env lean first, do not full-build>"`
5. Record the project id in `ARISTOTLE_JOBS.json` and the ledger.
