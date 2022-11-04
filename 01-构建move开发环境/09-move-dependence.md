# ```move中的依赖管理```

> 本教程是基于aptos搭建的move智能合约开发

## 1. move.toml

> 官方配置清单

```toml
[package]
name = <string>                     # e.g., "MoveStdlib"
version = "<uint>.<uint>.<uint>"    # e.g., "0.1.1"
license* = <string>]                # e.g., "MIT", "GPL", "Apache 2.0"
authors* = [<string>]                # e.g., ["Joe Smith (joesmith@noemail.com)", "Jane Smith (janesmith@noemail.com)"]
upgrade_policy* = <string>         # two different upgrade policies are supported:compatible & immutable

[addresses]  # (Optional section) Declares named addresses in this package and instantiates named addresses in the package graph
# One or more lines declaring named addresses in the following format
<addr_name> = "_" | "<hex_address>" # e.g., Std = "_" or Addr = "0xC0FFEECAFE"

[dependencies] # (Optional section) Paths to dependencies and instantiations or renamings of named addresses from each dependency
# One or more lines declaring dependencies in the following format
<string> = { local = <string>, addr_subst* = { (<string> = (<string> | "<hex_address>"))+ } } # local dependencies
<string> = { git = <URL ending in .git>, subdir = <path to dir containing Move.toml inside git repo>, rev = <git commit hash>, addr_subst* = { (<string> = (<string> | "<hex_address>"))+ } } # git dependencies

# or
[dependencies.<string>]
git = '<URL ending in .git>'
rev = '<git commit hash>'
subdir = <path to dir containing Move.toml inside git repo>
addr_subst* = { (<string> = (<string> | "<hex_address>"))+ }
[dependencies.<string>]
local = '<string>'
addr_subst* = { (<string> = (<string> | "<hex_address>"))+ }


[dev-addresses] # (Optional section) Same as [addresses] section, but only included in "dev" and "test" modes
# One or more lines declaring dev named addresses in the following format
<addr_name> = "_" | "<hex_address>" # e.g., Std = "_" or Addr = "0xC0FFEECAFE"

[dev-dependencies] # (Optional section) Same as [dependencies] section, but only included in "dev" and "test" modes
# One or more lines declaring dev dependencies in the following format
<string> = { local = <string>, addr_subst* = { (<string> = (<string> | <address>))+ } }

```

## 2. 各配置项示例
### 2.1 package
```toml
[package]
name = 'project_name'                     
version = '1.0.0'                       
license = 'MIT'               
authors = ["alice","bob"]              
upgrade_policy = "compatible"
```

### 2.2 addresses
```toml
[addresses]
sender = '0x6666'
from = "0x06"
to = "0x08"
std ="0x01"

# dev环境地址
[dev-addresses]
sender = '0x6666'
# test环境地址
[test-addresses]
sender = '0x6666'

```


### 2.3 package
```toml
[dependencies.AptosFramework]
git = 'https://github.com/aptos-labs/aptos-core.git'
rev = 'main'
subdir = 'aptos-move/framework/aptos-framework'

[dependencies]
AptosToken = { git = 'https://github.com/aptos-labs/aptos-core.git', rev = 'main',  subdir='aptos-move/framework/aptos-tokens'}

```


> 至此我们已经掌握了```move```开发如何进行依赖管理。进阶课程敬请期待。
