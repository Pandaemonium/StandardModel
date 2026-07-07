# Claim-grade regression audit (global over-claim sweep)

Job: `ne-solo-lane-q13-global-overclaim-regression-audit-20260707`.
Scope: the two-day carrier run hot spots - Q12 triality / non-permutation
bridge, Q10 inertia / scalar-amplitude, RG-Schur language, and P1 manuscript /
README carrier-map wording - screened against the four over-claim modes
(vacuity, hollow telescoping, docstring-outruns-kernel, false shape).

Method: read the Lean statements as the source of truth and compared them to
the surrounding docstrings, theorem names, task-board / ledger / docket prose,
and the README / P1 manuscript. No proofs or hypotheses were added. Two minimal
README wording corrections were applied (see section 4); everything else is
reported, not changed.

Verification commands run in this pass: none (no `lake build` / `lake env lean`
was executed). The findings below are prose-vs-statement mismatches read off
the source; they do not depend on rebuilding. Suggested verification commands
for the follow-up proof jobs are listed in section 3.

---

## 0. Headline

The draft Lean modules for the hot spots are, individually, unusually
disciplined: each carries an explicit "Claim boundary" note, guard-pinned
`#print axioms` blocks, and honest scope caveats. The mismatches are almost all
in the *aggregating prose* (README, ledger synthesis lines) that summarizes
several careful modules into one sentence and, in doing so, drops the caveat
that the module itself kept. The single in-Lean issue is a degenerate
non-vacuity witness (`E4_healing`).

Severity key: HIGH = a reader would conclude a physical / indefinite-metric /
RG result is machine-checked when only a weaker finite-algebra fact is; MEDIUM
= the finite fact is real but the wording promotes it past its stated boundary;
LOW = naming / notation friction, already disclosed nearby.

---

## 1. HIGH-severity mismatches

### H1. README carrier-map: `Q_A = Q(sum alpha)` "tying the carrier to the trusted kinematic mass"
- File / name: `README.md` (Carrier layer bullet); underlying Lean
  `PhysicsSM/Draft/NullEdge/Carrier/CarrierApertureIdentification.lean`
  (`Q_A_eq_totalSq`, `Q_A_zero_iff_totalSq_zero`).
- Mode: docstring-outruns-kernel.
- What Lean proves: `Q_A = Q(sum_e alpha_e)` for an *abstract* `QuadraticForm
  Q`, and `Q_A = 0 <-> Q(sum alpha) = 0` over a field. The file's own honesty
  note states the bridge to the trusted kinematic layer (`NBodyAperture` /
  Minkowski `det P` / Plucker mass) "is stated as a docstring correspondence
  here and made a literal iff only in the Minkowski specialization (a
  follow-up)".
- Why it matters: this is the load-bearing seam between the DRAFT carrier and
  the TRUSTED kinematic layer - exactly the finite-algebra-vs-physics
  distinction the charter protects. The README sentence reads as if the tie to
  the trusted mass is done; it is the open follow-up. The P1 v3 manuscript is
  correct here ("concrete identification with this paper's Minkowski `det P` is
  still OPEN").
- Safest wording (applied): describe it as the "abstract total-square identity
  `Q_A = Q(sum alpha)`" and add "concrete `Q_A`-to-`det P` identification" to
  the open-cruxes list. Target theorem that would retire the caveat: a
  Minkowski-specialized `Q_A = minkowskiSq (sum p_i)` bridged literally to
  `NBodyAperture.nbody_aperture_massless_iff_collinear`.

### H2. Ledger synthesis: "null nilpotency NOT RG-stable -> THE THESIS IS AN RG FACT"
- File / name: `AgentTasks/twoday-carrier-run-2026-07-07/LEDGER.md` lines
  2244-2245 (Q08 synthesis note); language echoed by
  `GOAL_PROMPT_CODEX.md` line 88 (RG-SCHUR target = "witness that null
  microstructure can generate non-null mass terms").
- Mode: docstring-outruns-kernel (prose asserts a proved "FACT").
- What Lean proves: `PhysicsSM/NullStrand/DualSolder/SpectralSchur.lean`
  proves the Schur-complement determinant factorization
  (`det_fromBlocks_eq_det_hidden_mul_det_schurComplement`) and one-step Schur
  stability of the algebraic class {Krein-self-adjoint, Gamma-odd}
  (`schurComplement_isKreinSelfAdjoint_of_blocks`,
  `schurComplement_isGammaOdd_of_blocks`). It does NOT contain a
  null-nilpotency instability witness. Both the docket (RG-Schur harvest
  bullet) and the later ledger integration entry say so explicitly: "Still
  OPEN/MEMO: concrete null-nilpotency instability witness ... physical RG
  interpretation."
- Why it matters: "null nilpotency is not RG-stable" is precisely the
  not-yet-witnessed direction; calling the thesis "an RG FACT from two
  independent directions" promotes a MEMO-grade strategy claim to a proved
  result, in the run's own running log. This is the kind of line that gets
  quoted downstream.
- Safest wording: demote to claim calculus, e.g. "RG = Schur (proved: Schur
  determinant + one-step Krein/Gamma-odd stability); null-nilpotency
  instability is `MEMO`/`C`-grade pending a witness, so 'the thesis as an RG
  fact' is a conjecture with a named gate, not a theorem." (Left as report per
  the "keep edits minimal" instruction; LEDGER is an append-only running log.)

---

## 2. MEDIUM-severity mismatches

### M1. README Weitzenboeck line `4 D^#D = ...` presented under a Krein reading
- File / name: `README.md` (Carrier layer bullet); Lean
  `PhysicsSM/Draft/NullEdge/Carrier/CarrierKreinSquare.lean`
  (`carrier_krein_square`).
- Mode: false shape (notation implies indefinite `#`).
- What Lean proves: `4 . (star D * D) = Q_A^# + Q_C^# + 4 Q_T + 4 E_#` for an
  *arbitrary* `StarRing` involution `star`. The module's honesty note is
  emphatic: "'Krein' is aspirational until J / kappa are pinned ... this
  identity is involution-agnostic - it is equally the Hilbert (kappa = 0)
  square under a plain C*-star." So the four-slot decomposition is a genuine
  kernel-checked *algebraic* identity, but the indefinite/Krein reading is not
  what the identity delivers.
- Why it matters: the README wrote `4 D^#D = Q_A + Q_C + 4 Q_T + 4 E`
  (undecorated blocks) inline with "mass channels" and immediately next to the
  certified `kappa = 2` positivity, so a reader fuses the algebraic identity
  with the indefinite-metric mass form. The P1 v3 manuscript deliberately keeps
  the `#` version OPEN and only lists `4 D^2 = Q_A + Q_C + 4 Q_T` as
  kernel-checked.
- Safest wording (applied): mark the identity as "an algebraic identity for an
  arbitrary `StarRing` involution `#`; the genuine indefinite/Krein reading is
  pinned separately" and restore the `#`-decorated blocks `Q_A^#`, `Q_C^#`,
  `E_#` to match the theorem.

### M2. `E4_healing` is a degenerate ("N = top") non-vacuity witness
- File / name:
  `PhysicsSM/Draft/NullEdge/GateI1/Q12GammaPrimeQuotient.lean`
  (`E4_healing`); board framing in `THREAD_BOARD.md` ("rational witnesses
  showing the gate is non-vacuous in both directions").
- Mode: hollow telescoping (a triviality dressed as depth).
- What Lean proves: `E4_healing : forall x, (fW (gW x) - gW (fW x)) in (top)`
  with proof `fun _ => Submodule.mem_top`. The statement is true for *any*
  operators - it never uses `fW`, `gW`, or non-commutation - because `N = top`
  makes the physical quotient `V'/N` the zero space, on which everything
  commutes vacuously. The companion `E4_commutator_can_fail` (for `N = bottom`)
  is a genuine witness; `E4_healing` is not.
- Why it matters: the pair is sold as showing the equivariance gate
  `physDescend_commutes_iff` "cuts both ways" on the physical sector. It only
  shows the criterion's right-hand side can be true or false as `N` ranges over
  the two extremes; it does not exhibit healing on a *nontrivial* quotient,
  which is the physically interesting case (non-commuting upstairs healing on a
  genuine `V'/N`). The docstring discloses the mechanism, so this is not
  deceptive, but the "non-vacuous in both directions" framing overstates.
- Safest target: replace/augment with a witness on a nontrivial radical, e.g.
  `N` a proper nonzero `f`,`g`-invariant subspace containing the commutator
  image but not all of `V'`, so `physDescend` is on a nonzero quotient and the
  descended operators genuinely commute while the upstairs pair does not.
  (Reported, not edited: this needs a new proof, which is out of scope for an
  audit pass and would be a good next Aristotle job - see J1.)

---

## 3. LOW-severity / naming friction (report only)

- L1. `carrier_krein_square` (theorem name) advertises "Krein" for an
  involution-agnostic identity. Disclosed at length in the same file's honesty
  note; keep the name but the surrounding summaries should not inherit "Krein"
  without the caveat (covered by M1).
- L2. README "five-document shortlist" and "master document map" reference
  `NULL_EDGE_RESULTS.md`, `docs/DOCUMENT_MAP.md`, and
  `AgentTasks/twoday-carrier-run-2026-07-07/SYNTHESIS_BEYOND_MASS.md`, none of
  which exist in the tree (`docs/` holds only `ARISTOTLE.md`, `NULLSTRAND.md`).
  Not an over-claim of Lean content, but a documentation-integrity gap that
  makes the trust-map unfollowable; flag for the doc owner.
- L3. Q10 `MassAmplitudeCensus` / `SylvesterInertiaBridge` /
  `MultiTimeEmbedding` and Q12 `Q12Triality` / `Q12NonPermBridge` /
  `Q12GammaPrimeQuotient`: docstrings and claim boundaries are accurate. In
  particular `genuine_triality_triple` is a real non-diagonal order-3
  intertwining triple for the `octSgn` product (not a relabelled diagonal
  character, `gmap_tri1_ne_phi`), and `perm_bridge_insufficient` faithfully
  proves "a non-permutation Hadamard bridge exists, no permutation bridge
  exists." No action.

---

## 4. Edits applied in this pass

Minimal, prose-only, in `README.md` (Carrier layer bullet and Open-cruxes
list):
1. H1: `Q_A = Q(sum alpha)` re-described as the abstract total-square identity;
   the concrete `Q_A`-to-`det P` (trusted kinematic mass) identification added
   to the open-cruxes list.
2. M1: the `4 D^#D` decomposition marked as an algebraic identity for an
   arbitrary `StarRing` involution with the indefinite/Krein reading pinned
   separately; blocks restored to `Q_A^#`, `Q_C^#`, `E_#` to match
   `carrier_krein_square`.

No Lean files were modified. No hypotheses, axioms, or proofs were added or
weakened. The finite-draft-algebra vs physical-theory distinction is preserved
(the edits move claims toward the more conservative side already taken by the
Lean modules and the P1 v3 manuscript).

---

## 5. Recommended next Aristotle proof jobs (OPEN / T|H -> stronger machine-checked)

These convert the three load-bearing caveats above into kernel-checked
statements. Each is stated so the reviewing agent can hand a clean target to
Aristotle.

### J1. Nontrivial-radical E4 healing witness (retires M2)
- Goal: in `Q12GammaPrimeQuotient`, exhibit `Vc`, a proper nonzero invariant
  `Nc < Vc`, and operators `f`,`g` preserving both, such that
  `forall x, f x /= g x` upstairs on `Vc` (genuine non-commutation) yet
  `forall x : Vc, (f (g x) - g (f x)) in Nc`, so `physDescend_commutes_iff`
  gives commuting descended operators on a *nonzero* `Vc/Nc`.
- Payoff: replaces the degenerate `N = top` witness with a real "healing on the
  physical quotient" theorem; upgrades the board's "cuts both ways" to a
  non-vacuous claim.
- Suggested check: `lake env lean
  PhysicsSM/Draft/NullEdge/GateI1/Q12GammaPrimeQuotient.lean` then
  `#print axioms` on the new witness.

### J2. Minkowski specialization `Q_A -> det P` bridge (retires H1)
- Goal: specialize `CarrierApertureIdentification.Q_A_eq_totalSq` to
  `Q = minkowskiSq`, `alpha_e = ` future-null momenta, and prove the literal
  `iff` linking `Q_A = 0` to
  `NBodyAperture.nbody_aperture_massless_iff_collinear` (the file names this as
  the intended follow-up). This is finite algebra bridging two existing APIs;
  no new physics.
- Payoff: turns the docstring correspondence into a theorem, making the
  carrier-to-trusted-kinematic tie a kernel fact rather than README prose.
- Suggested check: `lake build
  PhysicsSM.Draft.NullEdge.Carrier.CarrierApertureIdentification` plus a
  guard-block axiom pin.

### J3. RG-Schur null-nilpotency instability witness (retires H2)
- Goal: give a concrete finite block operator whose fine block is
  null-nilpotent (`D_hid^2 = 0` on the relevant sector, or the per-edge
  null-nilpotency condition), and prove its Schur complement / effective
  visible operator is NOT null-nilpotent (a nonzero mass term appears). This is
  the "null microstructure generates non-null mass" witness the RG-SCHUR lane
  registered and that `SpectralSchur.lean` currently omits.
- Payoff: supplies the missing second direction so the ledger's "RG fact"
  language can be stated at theorem grade instead of MEMO.
- Suggested check: `lake env lean
  PhysicsSM/NullStrand/DualSolder/SpectralSchur.lean` (or a new sibling file)
  and an axiom-footprint guard block.

### J4 (bonus). Off-flat forward-sector Krein positivity (the standing crux)
- Already tracked as the program's hardest open item (CRACK 3 in
  `CarrierFlatSectorPositivity`); listed here only to note it is the natural
  escalation once J1-J3 land, and that until it does, all indefinite-metric /
  spectral "mass form is positive" language must stay flat-sector-scoped.

---

## 6. Confirmed-clean (checked, no over-claim found)

- `PhysicsSM/Draft/NullEdge/Carrier/CarrierPontryaginWitness.lean`
  (`witness_mass_form_strictly_positive`): the README's "certified Pontryagin
  kappa = 2 fundamental symmetry with strictly positive flat-sector Krein mass
  form" is accurate - inertia `(2,2)` is certified
  (`finrank_eigenspace_plus/minus`) and the mass form value `|c|^2 > 0` is
  kernel-checked on the flat chiral-positive state.
- `Q12Triality`, `Q12NonPermBridge`, `Q12GammaPrimeQuotient` (apart from M2),
  `MassAmplitudeCensus`, `MultiTimeEmbedding`, `SylvesterInertiaBridge`,
  `SpectralSchur` (statements): claim boundaries match the kernel content.
