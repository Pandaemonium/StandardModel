# Strategy + proof: a finite Levinson theorem — bound states = scattering-phase winding (Conjecture L)

## Context (blind to the wider repo)

A finite null-edge program models a mass barrier as a discrete-time quantum walk (a
finite Dirac QCA), with oracle evidence that transmission falls with barrier mass and
a massless region is transparent. The missing SPINE is a theorem tying bound states to
measurable scattering data: a **finite Levinson theorem** — the number of bound states
of the barrier walk equals the winding of the scattering phase (and equals the
reflection-sector index). This unifies the program's protection machinery (a chiral/
reflection index forcing protected modes) with the scattering picture: bound states as
phase winding, protected modes as pinned winding. Discrete/quantum-walk Levinson
results exist (Cedzich–Grünbaum–Werner; Richard–Suzuki) to anchor as [import].

## Targets

1. **`finite_optical_theorem` (companion M-target, do first).** For a finite unitary
   walk S-matrix `S = !![r, t'; t, r']` (reflection/transmission amplitudes),
   unitarity `SᴴS = 1` gives the forward sum rule `|r|² + |t|² = 1` (probability
   conservation) and the phase relations between `r, t`. Prove it.
2. **`finite_levinson` (the spine).** On an explicit small barrier walk, prove:
   `#{bound states} = winding of arg(det S(θ))` over the quasi-energy `θ ∈ [0,2π)`
   `= reflection-sector index`. State the winding precisely (a finite integer, e.g. a
   discrete phase-increment sum), and prove the equality on a concrete rational-fixture
   barrier where both sides are finite computations.

**Kill (Conjecture L):** an explicit rational-fixture walk where the bound-state count
≠ the scattering-phase winding.

## Constraints

Kernel-checked only for proofs: no `sorry`/`admit`/`native_decide`/new `axiom`;
footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only; small explicit walks where scattering data are finite.
Clean-room from the cited discrete-Levinson math. Deliver Lean file(s) +
`ARISTOTLE_SUMMARY.md`: the finite optical theorem, the Levinson equality (on the
fixture), and an honest statement of what generalizes vs stays fixture-specific.
