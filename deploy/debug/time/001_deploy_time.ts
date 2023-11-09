import {execute} from 'rocketh';
import 'rocketh-deploy';
import {context} from '../../_context';

export default execute(
	context,
	async ({deploy, accounts, artifacts}) => {
		await deploy(
			'Time',
			{
				account: accounts['solidity-kit:deployer'] || accounts['deployer'],
				artifact: artifacts.Time,
				args: [accounts['solidity-kit:time-owner']],
			},
			{deterministic: true}
		);
	},
	{tags: ['Time', 'Time_deploy']}
);
