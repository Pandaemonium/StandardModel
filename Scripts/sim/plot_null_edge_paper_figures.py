"""Generate theorem-backed figures for the null-spinor Dirac-walk paper.

The numerical curves evaluate the exact finite matrices used in the Lean
modules.  They illustrate, but do not replace, the kernel-checked identities
and error bounds cited in the manuscript.
"""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch, Polygon


ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "Sources" / "figures"
OUT.mkdir(parents=True, exist_ok=True)

TEAL = "#006f62"
BLUE = "#3056a6"
MAGENTA = "#a13c78"
AMBER = "#bd7200"
RED = "#b43b34"
INK = "#20262e"
MUTED = "#65707c"
PALE = "#f3f6f7"


def save(fig, stem):
    fig.savefig(OUT / f"{stem}.pdf", bbox_inches="tight")
    fig.savefig(OUT / f"{stem}.png", dpi=220, bbox_inches="tight")
    plt.close(fig)


def architecture_figure():
    fig, ax = plt.subplots(figsize=(12.2, 3.4))
    ax.set_xlim(0, 12.2)
    ax.set_ylim(0, 3.4)
    ax.axis("off")

    centers = [1.35, 4.0, 6.75, 9.55]
    widths = [2.25, 2.25, 2.45, 2.55]
    titles = ["Null directions", "Exterior area", "Rest operator", "Unitary dynamics"]
    colors = [BLUE, AMBER, TEAL, MAGENTA]
    subtitles = [
        r"$p_i=\psi_i\psi_i^\dagger$",
        r"$z=\psi_1\wedge\psi_2$",
        r"$B_z^2=|z|^2\mathbf{1}$",
        r"$U_a=e^{-ika\Gamma}e^{-iaB_z}$",
    ]

    for x, w, title, color, subtitle in zip(centers, widths, titles, colors, subtitles):
        box = FancyBboxPatch(
            (x - w / 2, 0.48), w, 2.45,
            boxstyle="round,pad=0.02,rounding_size=0.06",
            linewidth=1.5, edgecolor=color, facecolor="white",
        )
        ax.add_patch(box)
        ax.text(x, 2.66, title, ha="center", va="center", fontsize=12.5,
                weight="bold", color=INK)
        ax.text(x, 0.76, subtitle, ha="center", va="center", fontsize=11.5,
                color=color)

    for x0, x1 in zip([2.5, 5.15, 8.0], [2.82, 5.47, 8.22]):
        ax.add_patch(FancyArrowPatch((x0, 1.7), (x1, 1.7), arrowstyle="-|>",
                                     mutation_scale=16, linewidth=1.5, color=MUTED))

    # Null-direction panel.
    ax.plot([0.55, 2.1], [1.14, 1.14], color="#ccd2d8", lw=1)
    ax.plot([0.82, 0.82], [0.98, 2.3], color="#ccd2d8", lw=1)
    ax.add_patch(FancyArrowPatch((0.82, 1.14), (1.88, 2.08), arrowstyle="-|>",
                                 mutation_scale=14, lw=2.4, color=BLUE))
    ax.add_patch(FancyArrowPatch((0.82, 1.14), (1.16, 2.25), arrowstyle="-|>",
                                 mutation_scale=14, lw=2.4, color=MAGENTA))
    ax.text(1.89, 2.15, r"$\psi_1$", color=BLUE, fontsize=11)
    ax.text(1.05, 2.34, r"$\psi_2$", color=MAGENTA, fontsize=11)

    # Exterior-area panel.
    origin = np.array([3.3, 1.12])
    u = np.array([1.05, 0.35])
    v = np.array([0.34, 1.0])
    poly = Polygon([origin, origin + u, origin + u + v, origin + v],
                   closed=True, facecolor="#f4d99f", edgecolor=AMBER, lw=1.5)
    ax.add_patch(poly)
    ax.add_patch(FancyArrowPatch(origin, origin + u, arrowstyle="-|>",
                                 mutation_scale=12, lw=2, color=BLUE))
    ax.add_patch(FancyArrowPatch(origin, origin + v, arrowstyle="-|>",
                                 mutation_scale=12, lw=2, color=MAGENTA))
    ax.text(4.0, 1.68, r"$|z|$", ha="center", va="center", fontsize=15,
            color=AMBER, weight="bold")

    # Rest-operator panel.
    ax.text(6.75, 1.82, r"$B_z=[\,0\ \ z\ ;\ \bar z\ \ 0\,]$",
            ha="center", va="center", fontsize=14, color=INK)
    ax.text(6.75, 1.30, r"$H_z(k)^2=(k^2+\det P)\mathbf{1}$",
            ha="center", va="center", fontsize=11.5, color=TEAL)

    # Tiny exact-band sketch.
    q = np.linspace(-np.pi, np.pi, 250)
    theta = 0.48
    omega = np.arccos(np.clip(np.cos(q) * np.cos(theta), -1.0, 1.0))
    xx = 9.55 + 0.91 * q / np.pi
    yy1 = 1.70 + 0.68 * (omega - np.pi / 2) / (np.pi / 2)
    yy2 = 1.70 - 0.68 * (omega - np.pi / 2) / (np.pi / 2)
    ax.plot(xx, yy1, color=TEAL, lw=2)
    ax.plot(xx, yy2, color=MAGENTA, lw=2)
    ax.plot([8.6, 10.5], [1.7, 1.7], color="#c8ced4", lw=0.8)
    ax.text(10.47, 1.54, r"$q$", color=MUTED, fontsize=9)

    ax.text(11.72, 1.72, r"$\omega_\pm$", ha="center", va="center",
            fontsize=11, color=INK)
    ax.add_patch(FancyArrowPatch((10.9, 1.7), (11.38, 1.7), arrowstyle="-|>",
                                 mutation_scale=14, lw=1.4, color=MUTED))

    ax.text(6.1, 0.16,
            r"$z=0\ \Longleftrightarrow\ $ collinear null directions"
            r" $\Longleftrightarrow\ $ closed rest gap",
            ha="center", va="center", fontsize=12.5, color=INK)
    save(fig, "null_spinor_architecture")


SIGMA_X = np.array([[0.0, 1.0], [1.0, 0.0]], dtype=complex)
SIGMA_Z = np.array([[1.0, 0.0], [0.0, -1.0]], dtype=complex)
I2 = np.eye(2, dtype=complex)


def involution_exp(g, x):
    return np.cos(x) * np.eye(g.shape[0], dtype=complex) - 1j * np.sin(x) * g


def exact_2d_flow(k, m, t):
    h = k * SIGMA_Z + m * SIGMA_X
    r = np.sqrt(k * k + m * m)
    if r == 0:
        return I2.copy()
    return np.cos(t * r) * I2 - 1j * np.sin(t * r) * h / r


def dbox_1d(kmax, mmax):
    cbox = (2 * kmax**2 + 2 * mmax**2 + kmax * mmax**2
            + kmax**2 * mmax + kmax * mmax)
    return 4 * cbox + 4 * (kmax + mmax) ** 2 * np.exp(kmax + mmax)


def convergence_figure():
    fig, ax = plt.subplots(figsize=(7.3, 4.4))
    ns = np.unique(np.geomspace(2, 512, 48).astype(int))
    t = 1.0
    cases = [(0.6, 0.8, TEAL), (1.0, 0.35, BLUE), (0.25, 1.1, MAGENTA)]
    for k, m, color in cases:
        exact = exact_2d_flow(k, m, t)
        errors = []
        for n in ns:
            step = involution_exp(SIGMA_Z, k * t / n) @ involution_exp(
                SIGMA_X, m * t / n
            )
            errors.append(np.linalg.norm(np.linalg.matrix_power(step, n) - exact, 2))
        ax.loglog(ns, errors, "o-", ms=3.2, lw=1.6, color=color,
                  label=rf"exact error: $k={k:g},\ \mu={m:g}$")

    kmax = max(c[0] for c in cases)
    mmax = max(c[1] for c in cases)
    envelope = dbox_1d(kmax, mmax) * t * t / ns
    ax.loglog(ns, envelope, "--", color=AMBER, lw=2.2,
              label=r"proved box envelope $D_{\rm box}t^2/n$")
    ref = errors[-1] * ns[-1] / ns
    ax.loglog(ns, ref, ":", color=MUTED, lw=1.4, label=r"reference slope $n^{-1}$")
    ax.set_xlabel("number of time slices $n$")
    ax.set_ylabel(r"operator error $\|U_{t/n}^n-e^{-itH}\|$")
    ax.set_title("Many-step convergence to Dirac evolution")
    ax.grid(True, which="both", alpha=0.22)
    ax.legend(frameon=False, fontsize=8.6, ncol=1)
    fig.tight_layout()
    save(fig, "null_spinor_continuum_rate")


I4 = np.eye(4, dtype=complex)
ALPHA1 = np.array(
    [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]],
    dtype=complex,
)
ALPHA2 = np.array(
    [[0, 0, 0, -1j], [0, 0, 1j, 0], [0, -1j, 0, 0], [1j, 0, 0, 0]],
    dtype=complex,
)
ALPHA3 = np.array(
    [[0, 0, 1, 0], [0, 0, 0, -1], [1, 0, 0, 0], [0, -1, 0, 0]],
    dtype=complex,
)
BETA = np.diag([1, 1, -1, -1]).astype(complex)


def split4(qx, qy, qz, theta):
    return (involution_exp(ALPHA1, qx) @ involution_exp(ALPHA2, qy)
            @ involution_exp(ALPHA3, qz) @ involution_exp(BETA, theta))


def eigenphases4(q, theta):
    vals = np.linalg.eigvals(split4(q[0], q[1], q[2], theta))
    return np.sort(np.angle(vals))


def bz_path(samples=70):
    points = [np.array(v, float) for v in [
        (0, 0, 0), (np.pi, 0, 0), (np.pi, np.pi, 0),
        (np.pi, np.pi, np.pi), (0, 0, 0),
    ]]
    labels = [r"$\Gamma$", "X", "M", "R", r"$\Gamma$"]
    path = []
    ticks = [0]
    for a, b in zip(points[:-1], points[1:]):
        segment = np.linspace(a, b, samples, endpoint=False)
        path.extend(segment)
        ticks.append(len(path))
    path.append(points[-1])
    return np.array(path), ticks, labels


def plot_bands(ax, theta, title):
    path, ticks, labels = bz_path()
    bands = np.array([eigenphases4(q, theta) for q in path])
    palette = [BLUE, TEAL, MAGENTA, AMBER]
    for j in range(4):
        ax.plot(bands[:, j], color=palette[j], lw=1.45)
    for t in ticks:
        ax.axvline(t, color="#d7dce0", lw=0.8)
    ax.axhline(0, color="#9aa3ac", lw=0.8)
    ax.set_xticks(ticks, labels)
    ax.set_ylim(-np.pi, np.pi)
    ax.set_yticks([-np.pi, 0, np.pi], [r"$-\pi$", "0", r"$\pi$"])
    ax.set_title(title)
    ax.set_ylabel("quasienergy phase")


def brillouin_figure():
    fig = plt.figure(figsize=(11.8, 7.6))
    gs = fig.add_gridspec(2, 2, height_ratios=[1.0, 0.92], hspace=0.34, wspace=0.28)
    ax0 = fig.add_subplot(gs[0, 0])
    ax1 = fig.add_subplot(gs[0, 1])
    ax2 = fig.add_subplot(gs[1, 0], projection="3d")
    ax3 = fig.add_subplot(gs[1, 1])

    plot_bands(ax0, 0.0, "Massless ordered walk")
    plot_bands(ax1, 0.35, r"Massive walk: $|z|a=0.35$")
    _, ticks, _ = bz_path()
    body_center_index = 0.5 * (ticks[3] + ticks[4])
    ax1.axvline(body_center_index, color=RED, lw=1.0, ls="--")
    ax1.annotate(
        r"body center: exact $\pm1$ modes for every $|z|a$",
        xy=(body_center_index, 0),
        xytext=(body_center_index - 82, 1.18),
        arrowprops={"arrowstyle": "->", "color": RED, "lw": 0.9},
        color=RED,
        fontsize=8.2,
    )

    for bits in np.ndindex(2, 2, 2):
        parity = sum(bits) % 2
        color = TEAL if parity == 0 else MAGENTA
        marker = "o" if parity == 0 else "^"
        xyz = np.array(bits) * np.pi
        ax2.scatter(*xyz, s=75, color=color, marker=marker, depthshade=False)
        ax2.text(*(xyz + np.array([0.07, 0.07, 0.07])),
                 "+I" if parity == 0 else "-I", fontsize=8, color=color)
    ax2.set_xticks([0, np.pi], ["0", r"$\pi$"])
    ax2.set_yticks([0, np.pi], ["0", r"$\pi$"])
    ax2.set_zticks([0, np.pi], ["0", r"$\pi$"])
    ax2.set_xlabel(r"$q_x$")
    ax2.set_ylabel(r"$q_y$")
    ax2.set_zlabel(r"$q_z$")
    ax2.set_title(r"Exact corner parity: $U=(-1)^r\mathbf{1}$")
    ax2.view_init(elev=22, azim=38)

    radii = np.linspace(0.015, 1.15, 100)
    directions = [
        (np.array([1.0, 0.0, 0.0]), "axis", BLUE),
        (np.array([1.0, 1.0, 0.0]) / np.sqrt(2), "face diagonal", TEAL),
        (np.array([1.0, 1.0, 1.0]) / np.sqrt(3), "body diagonal", MAGENTA),
    ]
    for direction, label, color in directions:
        deviations = []
        for r in radii:
            phases = np.abs(eigenphases4(direction * r, 0.0))
            deviations.append(np.max(np.abs(phases / r - 1.0)))
        ax3.plot(radii, deviations, lw=1.8, color=color, label=label)
    ax3.set_yscale("log")
    ax3.set_xlabel(r"radial lattice momentum $|\mathbf{q}|$")
    ax3.set_ylabel(r"max band deviation from $|\Omega|/|\mathbf{q}|=1$")
    ax3.set_title("Isotropic tangent, finite-spacing anisotropy")
    ax3.grid(True, which="both", alpha=0.22)
    ax3.legend(frameon=False, fontsize=8.5)

    fig.suptitle("High-symmetry audit of the finite 3+1 split walk", fontsize=15, y=0.99)
    save(fig, "null_spinor_3plus1_brillouin")


if __name__ == "__main__":
    architecture_figure()
    convergence_figure()
    brillouin_figure()
    print(f"Wrote paper figures to {OUT}")
