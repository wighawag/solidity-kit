const {loadEnv} = require('ldenv');
loadEnv();
require('@nomicfoundation/hardhat-network-helpers');
const {addForkConfiguration, addNetworksFromEnv} = require('hardhat-rocketh');
require('vitest-solidity-coverage/hardhat');

// console.log({
// 	BLOCK_TIME: process.env['BLOCK_TIME'],
// });

const defaultVersion = '0.8.20';
const defaultSettings = {
	optimizer: {
		enabled: true,
		runs: 999999,
	},
	outputSelection: {
		'*': {
			'*': ['evm.methodIdentifiers'],
		},
	},
};

const config = {
	solidity: {
		compilers: [
			{
				version: defaultVersion,
				settings: {...defaultSettings},
			},
		],
	},
	networks:
		// this setup forking for netwoirk if env var HARDHAT_FORK is set
		addForkConfiguration(
			// this add network for each respective env var found (ETH_NODE_URI_<network>)
			addNetworksFromEnv({
				hardhat: {
					initialBaseFeePerGas: 0,
					mining: {
						auto: true,
						interval: process.env['BLOCK_TIME'] ? parseInt(process.env['BLOCK_TIME']) * 1000 : undefined,
					},
				},
			})
		),
	paths: {
		sources: 'solc_0.8',
	},
	docgen: {
		templates: 'docs_templates',
		pages: 'files',
	},
	mocha: {
		require: 'named-logs-console',
	},
};

module.exports = config;
