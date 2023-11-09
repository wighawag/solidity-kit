import {execute} from 'rocketh';
import 'rocketh-deploy';
import {context} from '../../_context';

export default execute(
	context,
	async ({deploy, accounts, artifacts}) => {
		const {deployer} = accounts;
		await deploy(
			'Time',
			{
				account: deployer,
				artifact: artifacts.Time,
				args: [accounts.deployer],
			},
			{deterministic: true}
		);
	},
	{tags: ['Time', 'Time_deploy']}
);
