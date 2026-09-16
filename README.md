pwrusr
================================================================================
[![License Badge]][License]

Standardized cross-platform-capable user profile designed for power users

## System Guarantees
Users are guaranteed the following:
- Nushell (default)
  - pwrusr config and module
  - Plugins (standard)
    - nu_plugin_soak
- Rust
  - Components (standard)
    - analyzer
- Helix
- uenv

## Home Guarantees
- .config/
  - secret/
- .ssh/
  - key/
- sys/
  - cache/ state/
  - data/
    - desktop/
  - secret/
    - cache/ data/ state/
  - local/
    - bin/ etc/ lib/ opt/ var/ share/ src/ doc/
  - use/
    - exe/ cfg/ lib/ pkg/ data/ asset/ src/ doc/
  - of/
    - nu/
      - exe/ mod/
  - mnt/
  - srv/
    - git/
  - sync/
- proj/ repo/
- bak/ down/ tmp/
- data/ doc/ sort/ tpl/
- mix/
  - calc/ img/ mdl/ snd/ txt/ vid/ web/ 

## Environment Guarantees
- UENV_USR_SPEC = 'pwrusr'
- XDG: CONFIG CACHE DATA STATE
- CARGO_TARGET_DIR = ~/sys/cache/cargo

## Conventions
- Anything that isn't XDG compliant:
  - ~/sys/of/{name}, or
  - ~/sys/{cache data state}/{name}
- Third-party installs: ~/sys/local/
- First-party installs: ~/sys/use/


Repository
--------------------------------------------------------------------------------

Found a bug?  
Let us know! Upvote an existing issue or create one if not found.

Have questions, concerns, ideas, or requests?  
Upvote an existing discussion or create one if not found.

### Contributors
Contributors, please review [SOURCETRAIT.md](https://github.com/sourcetrait/sourcetrait_common/blob/dev/SOURCETRAIT.md).  

#### Copyright Assignment Agreement (CAA)
By committing to this repository you
[agree to assign](https://github.com/sourcetrait/sourcetrait_common/blob/dev/docs/legal/Copyright_Assignment_Agreement.md)
to [Asmov LLC](https://asmov.software)
all right, title, and interest worldwide in all copyright covering your
contribution.


License (AGPL3)
--------------------------------------------------------------------------------
pwrusr  
Developed by [SourceTrait](https://sourcetrait.com), a division of **Asmov LLC**  
Copyright (C) 2026 [Asmov LLC](https://asmov.software)  

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a [copy](./LICENSE-AGPL-3.txt) of the
GNU Affero General Public License along with this program.
If not, see https://www.gnu.org/licenses/.


[Docs Badge]: https://img.shields.io/badge/docs-blue
[License]: #License-AGPL3
[License Badge]: https://img.shields.io/badge/license-AGPL3-blue.svg
