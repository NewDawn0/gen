# gen

Gen is a project generation tool designed to streamline the process of creating new projects by automating common setup tasks. With Gen, you can quickly generate project structures tailored to your needs, using customizable generation rules stored in your `~/.config/gen/rules` directory.

## Installation

### Install using Cargo

```bash
cargo install --git https://github.com/NewDawn0/gen
```

### Install using Nix

#### Imperatively

```bash
git clone https://github.com/NewDawn0/gen
nix profile install .
```

#### Declaratively

1. Add it as an input to your system flake as follows:

```nix
{
  inputs = {
    # Your other inputs ...
    gen = {
      url = "github:NewDawn0/gen";
      inputs.nixpkgs.follows = "nixpkgs";
      # Optional: If you use nix-systems or rust-overlay
      inputs.nix-systems.follows = "nix-systems";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };
}
```

2. Add this to your overlays to expose gen to your pkgs:

```nix
(final: prev: {
  gen = inputs.gen.packages.${prev.system}.default;
})
```

3. Then you can either install it in your `environment.systemPackages` using:

```nix
environment.systemPackages = with pkgs; [ gen ];
```

or install it to your `home.packages`:

```nix
home.packages = with pkgs; [ gen ];
```

## Usage

Gen searches for generation rules in your `~/.config/gen/rules` directory.

### Finding Available Rules

To see the available rules, you can use the following command:

```bash
gen --list
```

Or, using the shorthand:

```bash
gen -l
```

### Creating Rules

To create a rule, make a directory with the name of your rule within the `~/.config/gen/rules` directory.

Special files:

- **SETUPFILE**: Contains commands to be executed before other files/directories are copied.
- **POSTSETUPFILE**: Contains commands to be executed after files have been copied, useful for actions like sourcing the environment.

Any other files and directories within the rule directory will be copied to the new project.

### Example

Let's create a `py` rule for creating Python projects:

```
~/.config/gen/rules/py/
    ├── .envrc
    ├── SETUPFILE
    └── POSTSETUPFILE
```

Contents of `SETUPFILE`:

```bash
python -m venv venv
```

Contents of `POSTSETUPFILE`:

```bash
python -m venv venv
direnv allow .
```

Contents of `.envrc`:

```bash
source venv/bin/activate
```

These files set up a virtual environment and activate it using `direnv`, providing a ready-to-use Python environment.
