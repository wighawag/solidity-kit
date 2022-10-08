import {HardhatUserConfig} from 'hardhat/types';

const config: HardhatUserConfig = {
	solidity: {
		compilers: [
			{
				version: '0.8.17',
				settings: {
					optimizer: {
						enabled: true,
						runs: 2000,
					},
				},
			},
		],
	},
	paths: {
		sources: 'src',
	},
};

export default config;
