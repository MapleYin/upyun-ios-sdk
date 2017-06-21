//
//  ImageProcess.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/21.
//
//

import Foundation

struct ShippingOptions: OptionSet {
    let rawValue: Int
    
    static let nextDay    = ShippingOptions(rawValue: 1 << 0)
    static let secondDay  = ShippingOptions(rawValue: 1 << 1)
    static let priority   = ShippingOptions(rawValue: 1 << 2)
    static let standard   = ShippingOptions(rawValue: 1 << 3)
    
    static let express: ShippingOptions = [.nextDay, .secondDay]
    static let all: ShippingOptions = [.express, .priority, .standard]
}

struct ImageProc : OptionSet {
    let rawValue: Int
    
    static let scale = ImageProc(rawValue: 1)
}


public enum ImageProcessType {
    
    /// 裁剪方向
    ///
    /**
     *  northwest     |     north      |     northeast
     *                |                |
     *                |                |
     *  --------------+----------------+--------------
     *                |                |
     *  west          |     center     |          east
     *                |                |
     *  --------------+----------------+--------------
     *                |                |
     *                |                |
     *  southwest     |     south      |     southeast
     */
    enum Direction:String{
        case northwest = "northwest"
        case north = "north"
        case northeast = "northeast"
        case west = "west"
        case center = "center"
        case east = "east"
        case southwest = "southwest"
        case south = "south"
        case southeast = "southeast"
    }
    
    
    /// 缩放
    ///
    /// - fixWAutoH: 限定宽度，高度自适应
    /// - fixHAutoW: 限定高度，宽度自适应
    /// - max: 限定最长边，短边自适应
    /// - min: 限定最短边，长边自适应
    /// - wORh: 限定宽度或高度，宽高不足时不缩放
    /// - wANDh: 固定宽度和高度，宽高不足时居中裁剪再缩放
    ///          ⚠️配合 force 使用时，宽高不足时只缩放，不裁剪
    /// - square: 图片缩放成正方形，宽高相等
    /// - ratio: 宽高等比例缩放，取值范围 [1-1000]
    /// - wRatio: 宽度按比例缩放，高度不变，取值范围 [1-1000]
    /// - hRatio: 高度按比例缩放，宽度不变，取值范围 [1-1000]
    /// - maxSize: 限定长边或短边，进行等比缩放，不裁剪
    /// - minSize: 限定长边或短边的最小值，进行等比缩放，不裁剪
    /// - pix: 宽高等比例缩放，直到宽高像素积小于但最接近指定值，取值范围 [1-25000000]
    /// - force: 不支持放大的参数
    enum scale {
        case fixWAutoH(Int)
        case fixHAutoW(Int)
        case max(Int)
        case min(Int)
        case wORh(CGSize)
        case wANDh(CGSize)
        case square(Int)
        case ratio(Int)
        case wRatio(Int)
        case hRatio(Int)
        case maxSize(CGSize)
        case minSize(CGSize)
        case pix(Int)
        case force
    }
    
    
    /// 裁剪
    ///
    /// - crop: 缩小或放大前进行裁剪
    /// - clip: 缩小或放大后进行裁剪
    /// - gravity: 裁剪开始的方位
    ///           ⚠️gravity 需要放在 crop 或 clip 的后面
    /// - roundrect: 裁剪时对四角进行圆化（圆角裁剪）
    enum cut {
        case crop(CGRect)
        case clip(CGRect)
        case gravity(Direction)
        case roundrect(Int)
    }
    
    enum watermark {
        
        /// 图片水印
        ///
        /// - url: 水印图片的 URI
        ///        ⚠️水印图片必须和待处理图片在同一服务名下
        /// - percent: 水印图片自适应原图短边的比例，取值范围 [0-100]
        /// - `repeat`: 水印图片是否重复铺满原图
        enum image {
            case url(String)
            case percent(Int)
            case `repeat`
        }
        
        /// 文字水印
        ///
        /// - content: 文字内容
        /// - size: 文字大小
        /// - font: 文字字体
        /// - color: 字体颜色
        /// - border: 文字描边
        enum text {
            enum FontFamily:String {
                case 宋体 = "simsun"
                case 黑体 = "simhei"
                case 楷体 = "simkai"
                case 隶书 = "simli"
                case 幼圆 = "simyou"
                case 仿宋 = "simfang"
                case 简体中文 = "sc"
                case 繁体中文 = "tc"
                case Arial = "arial"
                case Georgia = "georgia"
                case Helvetica = "helvetica"
                case TimesNewRoman = "roman"
            }
            case content(String)
            case size(Int)
            case font(FontFamily)
            case color(UIColor)
            case border(UIColor)
        }
        
        case align(Direction)  // 放置方位
        case margin(CGPoint)   // 横纵相对偏移
        case opacity(Int)      // 透明度
        case animate           // 允许对动态图片加水印
    }
    
    /// 旋转
    ///
    /// - horizons: 水平翻转
    /// - vertical: 垂直翻转
    /// - auto: 自动扶正
    /// - angle: 按角度旋转
    /// - flip: 翻转方向
    enum rotate {
        enum Orientation:String {
            case horizons = "left,right"
            case vertical = "top,down"
        }
        
        case auto
        case angle(UInt)
        case flip(Orientation)
    }
    
    case unsharp  // 锐化
    case gaussblur(Int,Int) // 高斯模糊 模糊半径x标准差
    
    
    /// 边框
    ///
    /// - size: 边框尺寸
    /// - color: 边框颜色
    enum border {
        case size(CGSize)
        case color(UIColor)
    }
    
    
    /// 画布
    ///
    /// - rect: 画布尺寸
    /// - color: 边框颜色
    enum canvas {
        case rect(CGRect)
        case color(UIColor)
    }
    
    
    /// 属性获取
    ///
    /// - base: 获取基本信息（包括宽、高、格式、帧数）
    /// - meta: 获取 EXIF 信息 + 基本信息
    /// - IPTC: 获取 IPTC 信息 + 基本信息
    /// - all: 获取图片所有信息，当前是 EXIF 信息 + IPTC 信息 + 基本信息
    enum info {
        case base
        case meta
        case IPTC
        case all
    }
    
    
    /// 结果输出
    ///
    /// - format: 输出格式
    /// - lossless: 无损压缩
    /// - quality: 设置压缩质量，可选范围[1-99]
    /// - compress: JPG 、 PNG 大小压缩优化
    /// - coalesce: 是否填充动态 GIF 图像中共同部分
    /// - progressive: JPG 图片渐进式加载，图片加载从模糊到清晰
    /// - noicc: 清除图片 ICC 信息
    /// - strip: 去除图片所有元信息
    /// - gifto: 多帧 GIF 图片转为单帧 GIF 图片
    /// - exifswitch: 保留 EXIF 信息 ，默认会删除 EXIF 信息
    enum result {
        enum FormatType:String {
            case jpg = "jpg"
            case png = "png"
            case webp = "webp"
        }
        case format(FormatType)
        case lossless
        case quality(Int)
        case compress
        case coalesce
        case progressive
        case noicc
        case strip
        case gifto
        case exifswitch
    }
    
    
    /// 主题色提取
    ///
    /// - excolor: 提取的颜色数量。可选值：[1-4096]
    /// - dec: 十进制
    /// - hex: 十六进制
    /// - exformat: 返回颜色的进制
    enum mainColor {
        case excolor(Int)
        enum colorFormat:String {
            case dec = "dec"
            case hex = "hex"
        }
        case exformat(colorFormat)
    }
    
    /// 静态图渐变
    ///
    /// - ttd: 自上而下
    /// - dtt: 自下而上
    /// - ltr: 自左向右
    /// - rtl: 自右向左
    /// - orientation: 方向
    /// - position: 开始位置,结束位置
    /// - colorStart: 开始位置颜色及透明度
    /// - colorEnd: 开始位置颜色及透明度
    enum gradual {
        enum Orientation:String {
            case ttd = "top,down"
            case dtt = "bottom,up"
            case ltr = "left,right"
            case rtl = "right,left"
        }
        case orientation(Orientation)
        case position(Int,Int)
        case colorStart(UIColor)
        case colorEnd(UIColor)
    }
}


class ImageProcess {
    
    let scale:ImageProcessType.scale
    
    
    init() {
        scale = .square(1)
    }
}

class Scale {
    
}














