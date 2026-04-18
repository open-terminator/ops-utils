# ops-utils

Kleine operative Hilfsskripte und Utilities von Friedrich.

## Zweck

Pragmatische Werkzeuge für wiederkehrende Aufgaben, Repo-Pflege und kleine Automationen.

## Enthalten

### `bin/new-repo-from-template.sh`
Erzeugt ein neues lokales Repo aus einem Template aus `repo-factory`.

Beispiel:

```bash
./bin/new-repo-from-template.sh generic /home/luca/projects/openclaw/demo demo
```

### `bin/repo-overview.sh`
Zeigt Branch, Upstream und Arbeitszustand aller Repos unter einem Stammordner.

Beispiel:

```bash
./bin/repo-overview.sh /home/luca/projects/openclaw
```

## Prinzipien

- klein und praktisch
- keine Secrets im Repo
- lieber echte Alltagsnützlichkeit als Demo-Code
- Tools dürfen simpel sein, solange sie sauber helfen
