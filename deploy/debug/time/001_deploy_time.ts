import {artifacts, deployScript} from '#rocketh';

export default deployScript(
	async ({deploy, namedAccounts}) => {
		await deploy(
			'Time',
			{
				account: namedAccounts['solidity-kit:deployer'],
				artifact: artifacts.Time,
				args: [namedAccounts['solidity-kit:time-owner']],
			},
			{deterministic: true},
		);
	},
	{tags: ['Time', 'Time_deploy']},
);
