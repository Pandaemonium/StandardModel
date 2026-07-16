# Impact Strategist audit - anomalous-Floquet stack (2026-07-14T01:16)

- Model/role: claude / Impact Strategist (solo mode, active=claude)
- Distinct lens from tonight's Visionary (directions) and Lab Manager (ops): this
  is about lede, audience, and grade-faithful publishability of what is LANDED.

## 1. Strongest honest lede

> "A finite, fully kernel-checked Floquet regulator reproduces the exact infrared
> structure of a single Weyl fermion - its `+1` chirality, its `-i(q.sigma)`
> linear dispersion, and its convergence to the exact relativistic Weyl evolution
> `exp(-i t (q.sigma))` - and a machine-checked no-go map states precisely which
> finite realizations cannot host that single Weyl without doubling."

Why this is the strongest HONEST lede:
- It leads with a POSITIVE reconstruction (the IR Weyl structure) that is genuinely
  landed and kernel-checked, not conjectural.
- It pairs it with a rigorous IMPOSSIBILITY map - a rare and credibility-building
  combination (few programs publish their own no-gos with the same rigor as their
  positive results; charter Sec 3.9).
- It does NOT claim the thing we have NOT shown: a finite null-edge REALIZATION of
  the isolated single Weyl. That remains the declared open frontier (Gate 1).

Ledes to AVOID (overclaim): "we built a single Weyl fermion from finite data,"
"we solved fermion doubling," "a null-edge Standard-Model fermion." All cross the
kernel boundary and would be caught by any adversarial reviewer.

## 2. Nearest-work comparison

- **Physics precedent (not ours):** Higashikawa-Nakagawa-Ueda `1806.06868` (single
  Weyl via Floquet unitary), Bessho-Sato `2006.04204` (NN with bulk topology),
  Rudner et al `1212.3324` (AFAI 0/pi edge modes). The PHYSICS mechanism is
  theirs; we must cite them as the existence/framing prior art, not reinvent.
- **Discrete-Dirac lineage:** Foster-Jacobson `1610.01142` (4D checkerboard, no
  doubling) - closest discrete-walk-to-Dirac prior art.
- **Our differentiator (the actual novelty):** a KERNEL-CHECKED formalization of
  the IR Weyl structure of a specific regulator PLUS a machine-verified no-go map
  (schedule-transport non-escape, 4x4-doubling-required with a proven non-canonical
  intertwiner, 0/pi census, O(1/n) continuum). No prior work formalizes this to the
  Lean-kernel standard. That is the defensible contribution: not new physics, but a
  new STANDARD OF RIGOR applied to a chiral-fermion regulator, with an honest
  impossibility frontier.
- **Formalization landscape:** PhysLean does not cover this; this would be a
  substantial independent physics formalization.

## 3. Target community (ranked by fit)

1. **Formal-methods / Lean-for-physics** (highest fit NOW): a large kernel-checked
   physics artifact with guards and an axiom-footprint discipline. The lede for
   them is "the most complete kernel-checked treatment of a Floquet chiral-fermion
   regulator, including its no-gos."
2. **Lattice / chiral-fermion theorists** (high fit, needs Gate 1 for the headline):
   they care about rigorous no-go maps for regulators and about whether a single
   edge Weyl is achievable. The no-go map is already of interest; Gate 1 makes it a
   headline.
3. **Math-physics / QCA / Floquet-topology** (medium): the index precursor + O(1/n)
   continuum + 0/pi census speak to this community.

## 4. Decisive result needed for excitement

- **For the physics headline:** Gate 1 - the HNU half-line boundary window-defect
  (`--hnu` oracle test, harness ready tonight). A stabilized additive `+1` = a
  finite construction of a single edge chiral mode (genuinely exciting, physics
  venue); `0`/paired = a sharp new no-go (still publishable, impossibility venue).
  DECISIVE EITHER WAY - this is the single result that flips the program from "a
  rigorous formalization" to "a headline physics claim."
- **For the formalization headline (available now):** no new result is needed - the
  landed stack already clears the bar for a formalization contribution.

## 5. Grade-faithful publication action

- **NOW (grade-faithful, no new science):** package the R-track + no-go map as a
  formalization note / preprint: "Kernel-checked infrared Weyl structure and a
  no-go map for a finite Floquet regulator." Claim calculus: IR Weyl structure and
  no-gos as `M` (machine-verified, program-internal); the continuum limit as `M`
  with the fixed-momentum / non-uniform boundary stated; the half-space and
  null-edge realization as `C` (pre-registered conjecture with Gate 1 as the gate
  + kill). Every headline maps to a `state/CLAIMS.json` row (per the EDU claim-map
  discipline). This is honestly publishable TODAY to the formal-methods community.
- **GATED (physics headline):** hold the "finite single edge Weyl" or "finite no-go
  for a single edge Weyl" lede until the Gate-1 `--hnu` oracle returns; then it is
  a grade-`T|H`/`M` headline for the lattice community.
- **DO NOT:** submit a physics-venue paper claiming a null-edge chiral fermion
  before Gate 1; that is the overclaim the whole no-go map exists to prevent.

## Action recommendation (one)

Prepare the formalization-note outline NOW (grade-faithful, formal-methods
audience) drawing only on landed M-grade results + the honest open frontier; and
make the Gate-1 `--hnu` oracle result the single gate that unlocks the physics-
venue headline. Sequence: formalization note (available) -> Gate-1 oracle ->
physics headline (gated). This maximizes near-term credible output while keeping
the exciting claim honestly gated.
