import {HardhatUserConfig} from 'hardhat/types';

const config: HardhatUserConfig = {
	solidity: {
		compilers: [
			{
				version: '0.8.20',
				settings: {
					optimizer: {
						enabled: true,
						runs: 999999,
					},
				},
			},
		],
	},
	paths: {
		sources: 'solc_0.8',
	},
};

export default config;
