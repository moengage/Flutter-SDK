### *Note:* Don't delete this file. 
File is added to resolve `The plugin "moengage_flutter" requires your app to be migrated to the Android embedding v2. Follow the steps on https://flutter.dev/go/android-project-migration and re-run this command.`

Looks like the concept of a plugin containing the `/example` folder is hard-coded into Flutter tool, it throws error when the folder is not found. Creating an empty '/example' folder is a temporary work around.

[Flutter issue link] (https://github.com/flutter/flutter/issues/66561)
