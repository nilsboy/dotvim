#!/usr/bin/env ts-node

// generate list of apis to load

import glob from "glob"
import path from "path"

for (const entry of glob.sync(path.join(`src/api/`, `*`))) {
  const basename = path.basename(entry)
}
