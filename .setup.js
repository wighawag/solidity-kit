#!/usr/bin/env node
const fs = require('fs-extra');
function copyFromDefault(p) {
	if (!fs.existsSync(p)) {
		const defaultFile = `${p}.default`;
		if (fs.existsSync(defaultFile)) {
			fs.copyFileSync(`${p}.default`, p);
		}
	}
}

['.vscode/settings.json'].map(copyFromDefault);

fs.emptyDirSync('_lib/openzeppelin');
fs.copySync('node_modules/@openzeppelin', '_lib/openzeppelin', {
	recursive: true,
	dereference: true,
});
