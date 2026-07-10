"""Generate the exact Brillouin-zone band audit figure for Paper I.

The plotted bands are not simulation output. They evaluate the exact identity

    cos(Omega) = cos(q) cos(theta)

on the principal quasienergy branch, with q = k a and theta = mu a.
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np


ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "Sources" / "figures" / "null_spinor_dirac_bands.pdf"
OUTPUT_PNG = ROOT / "Sources" / "figures" / "null_spinor_dirac_bands.png"


def principal_band(q: np.ndarray, theta: float) -> np.ndarray:
    """Return Omega in [0, pi] from the exact lattice dispersion."""

    argument = np.cos(q) * np.cos(theta)
    return np.arccos(np.clip(argument, -1.0, 1.0))


def main() -> None:
    q = np.linspace(-np.pi, np.pi, 1601)
    cases = [
        (0.0, "Massless: 0 and pi cones"),
        (0.22 * np.pi, "Massive: both cones gapped"),
    ]

    plt.rcParams.update(
        {
            "font.family": "DejaVu Sans",
            "font.size": 10,
            "axes.titlesize": 11,
            "axes.labelsize": 10,
            "legend.fontsize": 9,
        }
    )
    fig, axes = plt.subplots(1, 2, figsize=(9.2, 3.65), sharey=True)

    for ax, (theta, title) in zip(axes, cases, strict=True):
        omega = principal_band(q, theta)
        ax.plot(q / np.pi, omega / np.pi, color="#006f63", lw=2.2, label=r"$+\Omega$")
        ax.plot(q / np.pi, -omega / np.pi, color="#b23a48", lw=2.2, label=r"$-\Omega$")
        ax.axhline(0.0, color="#777777", lw=0.7)
        ax.axhline(1.0, color="#aaaaaa", lw=0.7, ls="--")
        ax.axhline(-1.0, color="#aaaaaa", lw=0.7, ls="--")
        ax.axvline(0.0, color="#cccccc", lw=0.7)
        ax.set_xlim(-1.0, 1.0)
        ax.set_ylim(-1.04, 1.04)
        ax.set_xticks([-1.0, -0.5, 0.0, 0.5, 1.0])
        ax.set_xticklabels([r"$-1$", r"$-1/2$", r"$0$", r"$1/2$", r"$1$"])
        ax.set_xlabel(r"crystal momentum $q/\pi$")
        ax.set_title(title)
        ax.grid(color="#e7e7e7", lw=0.55)

    axes[0].set_ylabel(r"quasienergy $\Omega/\pi$")
    axes[0].set_yticks([-1.0, -0.5, 0.0, 0.5, 1.0])
    axes[0].set_yticklabels([r"$-1$", r"$-1/2$", r"$0$", r"$1/2$", r"$1$"])
    axes[0].scatter([0.0], [0.0], color="#202020", s=28, zorder=4)
    axes[0].text(0.54, 0.43, r"$0$ cone", transform=axes[0].transAxes)
    axes[0].text(0.66, 0.88, r"$\pi$ cone", transform=axes[0].transAxes)

    theta_pi = cases[1][0] / np.pi
    axes[1].annotate(
        r"rest energy $\theta$",
        xy=(0.0, theta_pi),
        xytext=(0.18, 0.42),
        textcoords="axes fraction",
        arrowprops={"arrowstyle": "->", "color": "#333333", "lw": 0.9},
    )
    axes[1].text(0.57, 0.83, r"zone-edge gap $2\theta$", transform=axes[1].transAxes)
    axes[1].legend(loc="lower right", frameon=False)

    fig.suptitle(
        r"Exact bands: $\cos\Omega=\cos q\,\cos\theta$",
        fontsize=12,
        y=1.01,
    )
    fig.tight_layout()
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUTPUT, bbox_inches="tight", metadata={"Creator": "plot_null_spinor_dirac_bands.py"})
    fig.savefig(OUTPUT_PNG, dpi=220, bbox_inches="tight")
    plt.close(fig)
    print(OUTPUT)
    print(OUTPUT_PNG)


if __name__ == "__main__":
    main()
