# Summary of changes for run df1481ba-7a64-4e20-99b2-db3f355b8aea
Closed the audit gap by constructing a fully-grounded concrete `TwoBandFamily` instance and instantiating the flow-count law on it, in the new file `FlowOneInstance.lean`.

## What was done

The strengthened `TwoBandFamily` structure in `context/TwoBandEigenphaseAnalytic.lean` proves the 1D flow-count law (`flowDiff_eq_zero`, `no_single_crossing'`) but had **no** concrete instance, so nothing verified that a real walk satisfies its hypotheses. `FlowOneInstance.lean` now builds such an instance and discharges every field with no added abstract hypotheses.

Why not `U1c` itself: the flow-one pseudo-doubler `U1c(z) = diag(z,1)·coin` from `context/TwoBandCrossingDoubling.lean` has BOTH its `+1` and `−1` crossings at the same momentum (`z = −1`, where `U1c(−1)` has eigenvalues `+1` and `−1` simultaneously). There the second eigenvalue sits on the real axis, which violates `CrossingData.hother_ne`. So the pseudo-doubler cannot satisfy the strengthened fields (this is documented in the file's header).

Instead I instantiate the simplest genuine two-band walk with exactly the required crossing structure: `U(k) = diag(e^{ik}, i)`. Its two eigenphase bands are `e^{ik}` (winding once) and the constant `i`. Over one period it has exactly two transversal simple `±1` crossings — a `+1` (`0`-)crossing at `k = 0` and a `−1` (`π`-)crossing at `k = π` — each with the second eigenvalue equal to the constant `i`, off the real axis.

All fields are proved from scratch, including the genuine analysis: continuity of the family, `2π`-periodicity, unitarity, the explicit characteristic-polynomial factorization `(X - e^{ik})(X - i)` and its root multiset `{e^{ik}, i}`, the crossing list `[⟨0,true,1⟩, ⟨π,false,1⟩]`, the `hbracket`/`hisolate` sample-bracketing, the `hclean` bracket-cleanliness (no other `±1` eigenvalue inside each bracket — via `sin k = 0` on the closed brackets forcing the crossing momentum), and the full `CrossingData` `other`/`hother`/`hroots`/`hother_ne` continuous-second-branch fields.

The two grounded results for this explicit walk are:
- `flowOne_flowDiff_eq_zero : flowDiff flowOneFamily.cs = 0`
- `flowOne_no_single_crossing : flowOneFamily.cs.length ≠ 1`

## Verification

The file builds cleanly (only pre-existing warnings remain in the `context/` files, which were left untouched). `flowOneFamily`, `flowOne_flowDiff_eq_zero`, and `flowOne_no_single_crossing` all depend only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`. There are no `sorry`s, no `native_decide`, no added axioms, and the `TwoBandFamily` structure was not weakened. This is the full (non-partial) construction. The two context files were added as library roots in `lakefile.toml` so the new file can import them.
