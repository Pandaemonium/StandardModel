# Fable-5 call 06 (solo run): mass-gap flagship semantic-alignment + manuscript finish

You are the most capable mathematical-physics referee + Lean semantic-alignment
auditor on this program. This is a **solo autonomous run** (finite,
machine-verified: *mass is the obstruction to coherent null transport*). Since
your last review (call-05) I have (1) written the dynamics section §9a, (2) added
a finite S-matrix scattering simulator, (3) completed + verified the references,
and — the headline — (4) **landed a new kernel flagship**: the parametrized
mass-gap theorem you ranked as the #1 next move. I need two things: a
**semantic-alignment audit of that Lean flagship** (does the kernel statement say
the intended physics?) and a **final "is the manuscript finished" judgment**.

## Program state (standalone; assume no prior knowledge)

Kernel-checked (Lean 4, axiom-audited, guard-pinned) results: §3 the Plücker mass
`det P = Σ|ψ_i∧ψ_j|²`; §4 the four-channel Krein budget `4 D^#D = Q_A+Q_C+4Q_T+
4E_#`; the Rayleigh keystone `sector_ground_mass`; `T2_positive_mass` (an explicit
two-edge Cl(4) carrier with a positive-definite physical sector — a genuine
positive squared mass at the fixed couplings `(λ,κ)=(2,1)`); the free §3↔§4
bridge; and the **new mass-gap flagship below**, which generalizes T2 to the whole
`(λ,κ)` coupling plane. Grades: **T** source-verified, **M** kernel-checked,
**MEMO** expert/LLM-oracle prose, **C** pre-registered conjecture with a kill.

## The new kernel flagship — `MassGapWitness` (audit this VERBATIM)

The claim it is meant to make, in physics words: on the two-edge Cl(4) carrier the
physical-sector mass form reduces to a 3×3 Hermitian block `B(λ,κ)` with aperture
strength `λ` and closure strength `κ`; its **spectrum is `{λ−κ, λ, λ+κ}`**, so
the **squared mass gap (least eigenvalue) is `λ − κ` = aperture − closure**, the
state is **massive iff `|κ| < λ`**, and **massless exactly on the critical line
`κ = λ`** (for `λ > 0`). The full Lean source is embedded (via --source-file).

**Your semantic-alignment task on this file — be adversarial:**
1. Does `B` (the `def`) actually encode the intended block — aperture `λ` on the
   diagonal, closure `κ` as the *skew imaginary* off-diagonal `κI` / `−κI`? Is the
   sign/placement the intended chromomagnetic closure, or could it be a different
   matrix that happens to have the same spectrum?
2. Is `B_posDef_iff : B.PosDef ↔ κ < λ ∧ −λ < κ` the intended "massive iff
   aperture dominates closure"? (Note `PosDef` here is the complex-Hermitian
   positive-definiteness with `open scoped ComplexOrder`.)
3. Is `B_least_eigenvalue : IsLeast (range eigenvalues) (λ−κ)` genuinely "the
   squared mass gap is `λ−κ`", or a weaker/mis-stated fact? Is the hypothesis
   `0 ≤ κ ≤ λ` the right domain; is `IsLeast` over the right set?
4. The massless line is split into `B_massless_iff` (unconditional, includes a
   `λ=0` disjunct) and `B_massless_iff_of_pos` (the `λ>0` physical line). Is that
   the honest statement, and is `det B = λ(λ²−κ²)` (`B_det`) right?
5. Any over-claim: does the file's docstring claim more than the theorems prove?
   Is calling this "the mass gap = aperture − closure" earned, or is there a gap
   between "least eigenvalue of an abstract 3×3 block" and "a physical mass gap"?

Report any mismatch between the intended physics and the kernel statements — that
is the whole point. The proof is kernel-checked and guard-pinned to
`[propext, Classical.choice, Quot.sound]`; I am NOT asking you to check the proof,
only whether the STATEMENTS are the intended mathematics.

## The manuscript — is it finished?

The complete manuscript is embedded (via --source-file). Since call-05 the changes
are: §4 now has a "mass phase diagram" paragraph (upgraded to full **M** by the
flagship above); §9a "A finite dynamics layer" (D1–D5 M-scaffolds + four
Lean-anchored simulators, with the honest framing that conservation is a *generic
sector-isometry* fact and the carrier-step instantiation is open); §2a gained a
Mlodinow–Brun mass-side comparator; references completed (Ji, Wilson,
Ginsparg–Wilson, Mlodinow–Brun, Bisio et al.). **Is it now publication-ready as a
self-contained Markdown draft?** If not, give a short, concrete, ordered
"remaining to finish" list — each item closeable in one editing pass. Flag any
stale grade, internal inconsistency, or over-claim, most severe first.

## Required output

- **Semantic-alignment verdict on `MassGapWitness`** (3–6 sentences): do the
  kernel statements say the intended physics? Any mismatch, most severe first.
- **Manuscript verdict** (3–5 sentences): finished or not, and the shortest path.
- **Ordered "remaining to finish" list** (if any), each item small + concrete.
- **Bottom line:** the 1–3 things that most stand between here and "done".

Be specific and technical; one sharp correct load-bearing criticism beats ten
generic ones. Report even if the news is bad.
