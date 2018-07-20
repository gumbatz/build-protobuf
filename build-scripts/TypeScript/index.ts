import { main as pbjs } from "protobufjs/cli/pbjs" ;
import { main as pbts } from "protobufjs/cli/pbts" ;
import { readdirSync, mkdirSync, existsSync } from "fs";

var messageDirs = readdirSync("Messages");

var javaScriptDir="Compiled/TypeScript";
if (!existsSync(javaScriptDir)) {
    mkdirSync(javaScriptDir);
    console.log(`Created directory {${javaScriptDir}}.`);
}

messageDirs.forEach(dir => {
    var lowerdir = dir.toLocaleLowerCase();
    var packageDir = `${javaScriptDir}/messages-${lowerdir}`;
    if (!existsSync(packageDir)) {
        mkdirSync(packageDir);
        console.log(`Created directory {${packageDir}} for package {${dir}}`);
    }

    var messageFile = `${packageDir}/index.js`;
    pbjs([
        "--target", "static-module",
        "--wrap", "commonjs",
        "--out", messageFile,
        `Messages/${dir}/*.proto` ], function(err, output) {
        if (err)
            throw err;
        console.log(`Written compiled messages of ${dir} to ${messageFile}.`);
        return output;
    });

    pbts([
        "--out", `${packageDir}/index.d.ts`,
        `${packageDir}/index.js` ], function(err, output) {
        if (err)
            throw err;
        console.log(`Written types for ${dir} to ${packageDir}/index.d.ts.`);
        return output;
    });
});