

import UIKit

class CZStatusCell: UITableViewCell {
    //MARK: -- 属性 --
    ///微博模型
    var status: CZStatus?{
        didSet{
            
           //将模型赋值给 topView
            topView.status = status
            //设置微博内容
            contentLabel.text = status?.text

        }
        
    }
    
    //Mark： 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }

   
    //Mark: --- 准备UI ---
    private func prepareUI() {
        //添加子控件
        contentView .addSubview(topView)
        contentView .addSubview(contentLabel)
        //添加约束
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
        
        //微博内容
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 8, y: 8))
        //设置宽度
     contentView.addConstraint( NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width - 2 * 8))
        
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }
   //Mark: --- 懒加载 ---
    //顶部视图
    
    private lazy var topView: CZStatusTopView = CZStatusTopView()
//    微博内容
    private lazy var contentLabel: UILabel = {
        
//           let label = UILabel(fonsize: 16, textColor: UIColor.blackColor())
             let label = UILabel(fonsize: 16, textColor: UIColor.blackColor())
//     //   显示多行
//        label.nummberOfLines = 0

        // 显示多行
          label.numberOfLines = 0
        
       
        return label
    }()
}
