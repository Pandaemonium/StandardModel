# Continuum and 3+1 synthesis: three independent scientific gates

Date: 2026-07-13
Role: Visionary / Skeptic synthesis
Work items: `CONT-FOURIER-001`, `QCA-3PLUS1-001`

## Executive conclusion

The program is no longer blocked by a vague phrase such as "recover 3+1
physics."  It has three logically independent gates:

1. **Regulator convergence:** does the exact finite HNU update converge to the
   intended continuum time evolution in a genuine norm?
2. **Global chirality accounting:** where is the charge that balances the
   exact local HNU Weyl orientation, counting both zero and pi quasienergy?
3. **Mass selection:** why is the Pluecker rest operator embedded in the chosen
   doubled regulator sector, rather than merely being compatible with it?

A theorem at one gate cannot be promoted as evidence that the other two have
closed.

## Gate R: continuum regulator

Already landed:

- exact HNU endpoint and exact unitarity;
- exact infrared derivative with the intended Weyl generator;
- exact continuum momentum-space Dirac flow and time-group law;
- strong continuity of every `L2` orbit;
- compact-support generator measurability and `L2` membership;
- a Duhamel difference-quotient bound and an integrable compact-support
  dominator.

One theorem remains in the current compact-support generator file:
`CompactSupportL2Generator.orbit_slope_tendsto`.  It must prove convergence in
the actual `Lp` norm for every punctured-neighborhood sequence tending to zero.
Pointwise differentiation or strong continuity is not a substitute.  Aristotle
task `398537a2-0de1-440d-820a-0764b9bfb7b0` is restricted to this proof.

After it lands, the regulator lane still owes a quantitative HNU one-step error,
finite-time telescoping, and the changing-lattice position-space lift.  Those
are approximation theorems; they should not be conflated with the exact
continuum carrier's time group.

## Gate X: global 3+1 chirality

Already landed:

- exact local HNU Jacobian and local charge `+1`;
- exact zero and pi endpoint census;
- an enclosing-sphere degree/Chern-shaped bridge under displayed topology
  assumptions;
- finite parent, transverse, half-space, and boundary-control modules;
- multiple no-go results showing finite periodic or spin-blind realizations
  relocate or balance the partner rather than erase it.

The latest global-ledger candidate proves that exact endpoint values populate
both zero and pi sectors and that no endpoint-value-only function can recover
signed local charge.  This is the correct negative result: orientation needs
derivative or micromotion data.  Its partner theorem assumes a zero-total-charge
certificate and therefore does not derive global doubling from the endpoint.

There is a sharper geometric correction.  `HNUExactCore.endpoint_pi` makes the
endpoint equal to `-I` whenever any one momentum coordinate is pi.  The pi
sector is therefore an extended coordinate face, not merely a second isolated
point analogous to the infrared Weyl node.  The active successor is formalizing
the tangent-kernel consequence.  Until that is resolved, the pi face must not be
assigned an isolated three-dimensional Weyl charge.  A successful global theory
must explain how micromotion, a boundary construction, or an enlarged parent
operator refines this nodal surface into the signed datum used by the ledger.

The highest-value positive target is a boundary-accounting theorem that
combines a genuinely derived signed zero/pi certificate with the half-space
index.  A negative theorem identifying the minimal missing global datum is also
publishable and preferable to an invented charge assignment.

## Gate O: Pluecker mass and the regulator

`PlueckerHNUIntertwiner` now proves an exact compatibility result:

- the HNU tangent is the massless Weyl kinetic block;
- an explicit `4 x 2` embedding intertwines the two-component Pluecker rest
  operator with the live four-component complex mass operator;
- the rest operator is the normalized compression along that embedding;
- no nonzero `2 x 2` matrix anticommutes with all three HNU Pauli velocities.

Thus a single HNU Weyl point is necessarily massless in its two-component
representation, while a doubled four-component extension can carry the same
complex Pluecker coordinate.  This is a real theorem-level bridge and a useful
no-go.

It is not yet a derivation of mass from the regulator.  The embedding is one
explicit choice and `z` remains supplied by Pluecker data.  The active
classification job asks whether every compatible embedding lies in a
nontrivial normalized moduli space.  If so, a physical selector must come from
locality, phase transport, information cost, boundary response, or dynamics.

## One coherent paper-level ladder

The strongest honest narrative is:

```text
finite exact HNU endpoint
  -> exact local massless Weyl tangent
  -> compact-support and finite-time continuum convergence
  -> global zero/pi and boundary charge accounting
  -> necessary four-component doubling for Pluecker mass
  -> classification and selection of the embedding
  -> held-out phase-sensitive observable
```

The first, second, and part of the fifth arrows are theorem-level.  The third,
fourth, sixth, and seventh remain active research gates.  This separation is
not hedging; it identifies the shortest path from the current formal core to a
distinct physical theory.

## Dependency-ordered theorem portfolio

The next work should proceed in this order:

1. Close `orbit_slope_tendsto` without weakening its punctured-neighborhood
   `Lp` convergence statement.
2. Compose the exact generator theorem with a quantitative HNU one-step bound
   and a uniform finite-time telescope.
3. Prove the pi-face tangent-kernel theorem and classify the normal derivative.
4. Decide whether micromotion or the parent/boundary operator supplies a signed
   refinement of the extended pi face; otherwise record a no-adapter theorem.
5. Classify all HNU--Pluecker intertwiners and identify the extra principle that
   selects one equivalence class.
6. Only after 1--5, formulate a held-out observable that depends on the
   Pluecker phase or selected embedding and is not fixed by a renamed scalar
   mass.

This ordering prevents two recurrent category errors: using exact continuum
dynamics as evidence that the regulator converges, and using an endpoint
spectral census as if it already carried signed topological charge.
