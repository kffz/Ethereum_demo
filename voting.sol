contract Ballot{
	//声明结构体，代表一个独立的投票人
	struct Voter{
		uint weight; //累积的权重
		bool voted; //如果为真，表示该投票人已经投票
		address delegate; //地址类型，委托的投票代表
		uint vote; //投票选择的提案索引号
	}
	//一个独立提案结构体
	struct Proposal
	{
		bytes32 name;
		uint voteCount;
	}
	address public chairperson; 
	//声明一个地址类型的变量，保存每个独立地址的Voter结构体
	mapping(address=>Voter) public voters;
	//存储Proposal结构体的动态数组
	Proposal[] public proposals;
	//创建一个新的投票用于选出一个提案名"proposalNames"
	function Ballot(bytes32[] memory proposalNames) public {
		chairperson = msg.sender;
		voters[chairperson].weight = 1;
		//对提供的每一个提案名称，创建一个新的提案
		//对象添加到数组末尾
		for (uint i=0; i < proposalNames.length; i++)
			proposals.push(Proposal({
				name: proposalNames[i],
				voteCount: 0
			}));
	}
	//给投票人'voter'参加投票的投票权,
	//只能由投票主持人'chairperson'调用。
	function giveRightToVote(address voter) public {
		require(
			msg.sender == chairperson,
			"Only chairperson can give right to vote"
			);
		require(
			!voters[voter].voted,
			"The voter already voted."
		);
		require(voters[vote].weight == 0);
		voters[voter].weight = 1;
			//throw会终止和撤销所有的状态和以太改变
			//如果函数调用无效，这通常是一个好的选择
			//但是需要注意，这会消耗提供的所有gas
	}
	//委托你的投票权到一个投票代表'to'.
	function delegate(address to) punlic {
		Voter storage sender  = voters[msg.sender];
		require(!sender.voted, "You have already voted!");
		require(to != msg.sender, "Self-delegation is disallowed.")；
		//当投票代表'to'也委托给别人时，寻找到最终的投票代表
		while (voters[to].delegate != address(0) {
			to = voters[to].delegate;
			//每次委托后检查是否形成闭环
			require(to != msg.sender, "Found loop in delegation.");
		}
		sender.voted = true;
		sender.delegate = to;
		Voter storage delegate_ = voters[to];
		if (delegate_.voted) {
			//如果委托的投票代表已经投票，直接修改票数
			proposals[delegate_.vote].voteCount += sender.weight;
		} else {
			//如果投票代表还没有投票，则修改其投票权重
			delegate_.weight += sender.weight;
		}
	}

	function vote(uint proposal) {
		Voter storage sender = voters[msg.sender];
        require(!sender = voted, "已经投递")；
        sendr.voted = true;
        sender. vote = proposal;
        propasals[proposal].voteCount += "sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_) {
    	uint winningVoteCount = 0;
    	for (uint p = 0; p < proposals.length; p++){
    		winningVoteCount = proposals[p].voteCount;
    		winningProposal_ = p;
    	}
    }

    function winnerName() public view returns(bytes32 winnerName_){
    	winnerName_ = proposals[winningProposal()].name;
    }
}