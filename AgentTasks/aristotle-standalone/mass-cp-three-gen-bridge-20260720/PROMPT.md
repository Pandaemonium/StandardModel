# Lemma job: CP violation requires >= 3 generations (Jarlskog bridge, capstone)

Mathlib-only. Consolidating capstone tying the landed CKM Jarlskog invariant to the
Kobayashi-Maskawa three-generation requirement. Prove, for an `n x n` unitary CKM
matrix with the Jarlskog-type quartet invariant `J`:
1. for `n = 1`: `J` is trivially zero (no CP);
2. for `n = 2`: EVERY `2 x 2` unitary has all quartet invariants zero - a 2x2
   unitary can be made real by rephasing, so `J = 0` (no CP violation with two
   generations);
3. for `n = 3`: a nonzero `J` exists (reuse/rebuild the explicit Fourier witness),
   so CP violation is possible - the Kobayashi-Maskawa threshold;
4. state the bridge: physical CP violation in the quark sector requires `n >= 3`
   generations, matching the count `0 < ckmPhysCP(n) <-> 3 <= n`.
This connects the CKM Jarlskog module to the KM 3-family CP threshold. Explicit
small matrices; the `n=2` rephasing-to-real is the key new content. No new
axioms/native_decide; standard axioms; report axioms.
