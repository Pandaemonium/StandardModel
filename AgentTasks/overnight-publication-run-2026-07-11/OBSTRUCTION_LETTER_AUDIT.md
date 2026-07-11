# Independent audit: obstruction letter v1

Audited file:
`Sources/Null_Edge_Obstruction_Letter_Draft_2026-07-11.tex`

## Major finding

1. **The Gupta--Short corollary is source-verified, not kernel-checked.**
   `StationaryAmplitudeNoGo.stationary_forces_zero` is kernel-checked.  The
   assertions that the published Gupta--Short axis factor has the required
   degree-one Laurent form, all-momentum unitarity, origin normalization,
   nonzero stationary block, and Hermitian tangent are external-source
   checks; their matrices have not been encoded in this repository.  Therefore
   the abstract, setup, corollary, and appendix must not imply that this
   application is itself a Lean declaration.  Label it explicitly as a
   source-checked application of a kernel theorem and add it to the artifact
   table with that status.

## Minor findings

2. Change "the standard minimal architecture" to "a standard minimal
   architecture."  The theorem is decisive for the ordered successive-axis
   class, not a uniqueness theorem for all minimal `3+1` walks.

3. The classification module has an explicit `cos theta = 0` extra-zero
   control.  The `|cos theta| = 1` boundary is covered separately by massless
   corner controls, not by the same classification declaration.  Say this
   explicitly instead of grouping `{0, +/-1}` as if one theorem treats all
   three cases.

4. Restate the falsifiable class using the actual hypotheses of
   `live_degree_one_factorized_lower_bound`: four-component, one degree-one
   Laurent factor per axis, factorwise all-momentum unitarity, exact regulated
   tangents `alpha_1, alpha_2, alpha_3`, and a momentum-independent onsite
   coin.  "dimension-two-per-factor" is not a Lean hypothesis and should be
   removed.

5. The escape list should say that a successor must leave at least one theorem
   hypothesis.  The current list omits possibilities such as non-factorwise
   unitarity with an overall unitary product or a momentum-dependent onsite
   operation; those may be undesirable, but the theorem does not exclude
   them.

6. Replace "Every theorem above is a kernel-checked declaration" with "Every
   result labeled Kernel..." after giving the Gupta--Short application its
   separate source-checked label.

## Passed checks

- `det(U-I)=4 P_0` and `det(U+I)=4 P_pi` match the landed full-Bloch
  declarations.
- The principal-massive zero-set classification and its hypotheses match
  `FullBlochZeroClassification` exactly.
- The all-angle body-center `+1/-1` modes and no-uniform-gap consequence match
  `Finite3Plus1BrillouinAudit`.
- The stationary-amplitude theorem, relaxed non-involutory control, and
  all-onsite-coin alias theorem match their live Lean statements.
- Strict finite-range walk locality is kept separate from a Wilson Hamiltonian
  exponential.
- No vacuous theorem or missing nonzero control was found in the formal suite.

## Verdict

The formal obstruction suite is letter-worthy.  Apply the proof/source status
correction before circulation; the remaining edits are narrow scope hygiene.
