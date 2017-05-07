
#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const BSTitleViewY;
UIKIT_EXTERN CGFloat const BSTitleViewH;

/** 精华cell间距 */
UIKIT_EXTERN CGFloat const BSTopicCellMargin;
/** 精华cell文字内容的y值 */
UIKIT_EXTERN CGFloat const BSTopicCellTextY;
/** 精华cell底部工具条的高度 */
UIKIT_EXTERN CGFloat const BSTopicCellBottomBarH;

typedef enum{
    BSTopicTypeAll = 1,
    BSTopicTypePicture = 10,
    BSTopicTypeWord = 29,
    BSTopicTypeVoice = 31,
    BSTopicTypeVideo = 41
}BSTopicType;


UIKIT_EXTERN CGFloat const BSPictureMaxH;
UIKIT_EXTERN CGFloat const BSPictureZoomH;

UIKIT_EXTERN NSString *const BSUserMale;
UIKIT_EXTERN NSString *const BSUserFemale;

/** 最热评论label的高度*/
UIKIT_EXTERN CGFloat const BSCommentTitleH;
