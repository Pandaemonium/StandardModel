"""K6 determinant-parity kill probe: what invariant forces the zero mode?

Context: the locus scan (`p1_zero_mode_locus_scan.py`;
`AgentTasks/twoday-carrier-run-2026-07-07/TSOLDER_KAPPA_ANALYSIS.md` sec 4b)
found that EVERY cyclically symmetric celestial decoration of the length-V
transport cycle pins an EXACT unit eigenvalue of the 2V-dim transfer W,
while generic (asymmetric) decorations give only a near-unit eigenvalue.
The SevenChallenges memo (finding 8, `SEVENCHALLENGES_ANALYSIS.md`)
proposes the invariant is an equivariant reciprocal-pairing / determinant
-parity index: on a cyclic sector, a symmetry `J U_chi J^{-1} = U_chi^{-1}`
pairs eigenvalues reciprocally, and an odd-dimensional sector then forces a
+-1 eigenvalue, with `det U_chi in {+-1}` fixing the parity.

Pre-registered kill (memo): find a symmetric decoration with the same
cyclic data but flipped determinant parity and NO pinned eigenvalue -> the
invariant is not determinant parity.

Since pinning is UNIVERSAL for symmetric decorations (locus scan), the
honest decisive probe is structural, not a pinning-varies sweep:

 Q1. Does W commute with a cyclic symmetry operator S (bare or
     phase-dressed shift)?  [equivariance premise]
 Q2. Block-diagonalize by S. In which sector does the unit eigenvalue
     live? Is that sector odd- or even-dimensional?  [where the index sits]
 Q3. In that sector, is there a reciprocal pairing (spectrum closed under
     lambda -> 1/lambda, i.e. lambda -> conj lambda on the unit circle)?
     What is det U_chi, and is it real (+-1)?  [the memo's J-structure]
 Q4. KILL/robustness: break the cyclic symmetry by a controlled epsilon.
     Does the EXACT unit eigenvalue survive (contradicts "symmetry forces
     it") or drift to near-unit (confirms symmetry is essential)?
 Q5. FALSIFIER search: across symmetric decorations, does the proposed
     invariant (odd-sector + det parity) EVER mispredict pinning?

Output guides the T1 Lean statement: it says which theorem class
(equivariant reciprocal-pairing index) is correct BEFORE formalization.

Numeric oracle only; NOT a Lean result.
Usage: python Scripts/oracle/p1_zeromode_symmetry_invariant.py
"""

import numpy as np
from p1_zero_mode_locus_scan import transfer_from_data

RNG = np.random.default_rng(20260708)


def symmetric_data(v, t_abs, winding, phi0=0.0):
    """Uniform |t|, winding flip phases: the symmetric-cone gauge data."""
    return t_abs, [phi0 + 2.0 * np.pi * winding * leg / v for leg in range(v)]


def cyclic_shift(v):
    """Bare leg-shift S on the 2V-dim (leg, orientation) space, +1 leg."""
    s = np.zeros((2 * v, 2 * v), dtype=complex)
    for leg in range(v):
        for orient in (0, 1):
            s[2 * ((leg + 1) % v) + orient, 2 * leg + orient] = 1.0
    return s


def dressed_shift(v, alpha):
    """Phase-dressed shift: S times diag phase e^{i alpha * leg} per leg."""
    s = cyclic_shift(v)
    d = np.diag([np.exp(1j * alpha * leg)
                 for leg in range(v) for _ in (0, 1)])
    return s @ d


def find_symmetry(w, v):
    """Return an order-V unitary S commuting with W (bare or dressed)."""
    for alpha in [0.0] + [2 * np.pi * k / v for k in range(v)]:
        s = dressed_shift(v, alpha)
        if np.linalg.norm(w @ s - s @ w) < 1e-9:
            return s, alpha
    # last resort: search a continuous dressing phase
    best, bestval = None, 1e9
    for alpha in np.linspace(0, 2 * np.pi, 400, endpoint=False):
        s = dressed_shift(v, alpha)
        val = np.linalg.norm(w @ s - s @ w)
        if val < bestval:
            best, bestval, besta = s, val, alpha
    return (best, besta) if bestval < 1e-6 else (None, None)


def sector_analysis(w, s, v):
    """Project W onto S-eigenspaces; per sector report dim, det, pinning."""
    svals, svecs = np.linalg.eig(s)
    # group eigenvectors by S-eigenvalue (the cyclic sector label)
    order = np.argsort(np.angle(svals))
    svals, svecs = svals[order], svecs[:, order]
    sectors = []
    used = np.zeros(len(svals), bool)
    for i in range(len(svals)):
        if used[i]:
            continue
        grp = [j for j in range(len(svals))
               if abs(np.angle(svals[j] / svals[i])) < 1e-6]
        for j in grp:
            used[j] = True
        basis = svecs[:, grp]
        basis, _ = np.linalg.qr(basis)  # orthonormalize the sector
        wsec = basis.conj().T @ w @ basis
        ev = np.linalg.eigvals(wsec)
        pinned = np.min(np.abs(ev - 1.0)) < 1e-7 or \
            np.min(np.abs(ev + 1.0)) < 1e-7
        det = np.linalg.det(wsec)
        sectors.append(dict(slabel=np.angle(svals[i]), dim=basis.shape[1],
                            det=det, pinned=pinned, ev=ev))
    return sectors


def has_reciprocal_pairing(ev, tol=1e-6):
    """Spectrum closed under lambda -> 1/lambda (= conj on unit circle)."""
    ev = list(ev)
    for lam in ev:
        if abs(abs(lam) - 1) > 1e-6:
            return False
        if not any(abs(mu - np.conj(lam)) < tol for mu in ev):
            return False
    return True


def run(v, t_abs, winding, label):
    t, fph = symmetric_data(v, t_abs, winding)
    w = transfer_from_data(v, t, 0.0, fph)  # holonomy folded into fph winding
    unit_defect = np.linalg.norm(w.conj().T @ w - np.eye(2 * v))
    s, alpha = find_symmetry(w, v)
    ev_all = np.linalg.eigvals(w)
    pinned_global = np.min(np.abs(ev_all - 1.0)) < 1e-7
    print(f"=== {label}: V={v} |t|={t_abs:.3f} winding={winding} ===")
    print(f"  W unitary defect {unit_defect:.1e}; global unit eigenvalue "
          f"pinned: {pinned_global} (min|ev-1|={np.min(np.abs(ev_all-1)):.1e})")
    if s is None:
        print("  NO commuting cyclic symmetry found (Q1 FAIL)")
        return
    print(f"  Q1: commuting symmetry S found, dressing alpha={alpha:.4f}, "
          f"[W,S]={np.linalg.norm(w@s-s@w):.1e}")
    secs = sector_analysis(w, s, v)
    for sec in secs:
        recip = has_reciprocal_pairing(sec['ev'])
        detreal = abs(sec['det'].imag) < 1e-6
        print(f"  sector s={sec['slabel']:+.3f}: dim={sec['dim']} "
              f"pinned={sec['pinned']} det={sec['det']:+.3f} "
              f"(|det|={abs(sec['det']):.3f}, real={detreal}) "
              f"reciprocal={recip}")
    # Q5 falsifier check: does (pinned) <=> (a sector has a real det with
    # the reciprocal structure and forced eigenvalue)?
    pin_sectors = [sec for sec in secs if sec['pinned']]
    print(f"  -> {len(pin_sectors)} pinned sector(s); "
          f"pinning lives at sector label(s) "
          f"{[round(sec['slabel'],3) for sec in pin_sectors]}")


def break_symmetry_test(v, t_abs, winding):
    """Q4: perturb ONE leg's flip phase; does exact pinning survive?"""
    t, fph = symmetric_data(v, t_abs, winding)
    print(f"=== Q4 symmetry-breaking (V={v}, |t|={t_abs:.3f}) ===")
    for eps in (0.0, 1e-3, 1e-2, 1e-1):
        fph2 = list(fph)
        fph2[0] += eps
        w = transfer_from_data(v, t, 0.0, fph2)
        d = np.min(np.abs(np.linalg.eigvals(w) - 1.0))
        print(f"  eps={eps:.0e}: min|ev-1| = {d:.2e} "
              f"({'EXACT pin' if d < 1e-7 else 'drifted'})")


def main():
    inv_t = 1.0 / np.sqrt(3.0)
    for v in (3, 4, 5):
        run(v, inv_t, 1, "symmetric winding-1")
    run(4, 0.5, 2, "symmetric even-V half-winding")
    print()
    break_symmetry_test(3, inv_t, 1)
    break_symmetry_test(4, 0.5, 2)
    # Q5 broad falsifier sweep: random symmetric decorations, does the
    # equivariant premise + a pinned sector always co-occur with a global
    # unit eigenvalue?
    print("\n=== Q5 falsifier sweep (random symmetric decorations) ===")
    bad = 0
    for _ in range(40):
        v = int(RNG.integers(3, 7))
        t_abs = float(RNG.uniform(0.2, 0.95))
        winding = int(RNG.integers(0, v))
        t, fph = symmetric_data(v, t_abs, winding)
        w = transfer_from_data(v, t, 0.0, fph)
        pinned = np.min(np.abs(np.linalg.eigvals(w) - 1.0)) < 1e-7 or \
            np.min(np.abs(np.linalg.eigvals(w) + 1.0)) < 1e-7
        s, _ = find_symmetry(w, v)
        equivariant = s is not None
        if equivariant and not pinned:
            bad += 1
            print(f"  FALSIFIER: V={v} |t|={t_abs:.3f} w={winding} "
                  f"equivariant but NOT pinned")
    print(f"  falsifiers found: {bad}/40 "
          f"({'mechanism SURVIVES' if bad == 0 else 'mechanism NEEDS REVISION'})")


if __name__ == "__main__":
    main()
