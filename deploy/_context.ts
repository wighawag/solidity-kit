import artifacts from '../generated/artifacts';
import 'rocketh-signer';

export const context = {
	accounts: {
		'solidity-kit:deployer': {
			default: 0,
		},
		'solidity-kit:time-owner': {
			default: 0,
		},
	},
	artifacts,
} as const;
