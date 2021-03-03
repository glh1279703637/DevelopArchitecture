//
//  JCryptHelp.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/11/4.
//  Copyright © 2020 Jeffery. All rights reserved.
//

import Foundation
import CommonCrypto

// Secure Hash Algorithm
enum kSHAType {
   case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    var infoTuple: (algorithm: CCHmacAlgorithm, length: Int) {
        switch self {
        case .MD5:      return (algorithm: CCHmacAlgorithm(kCCHmacAlgMD5),    length: Int(CC_MD5_DIGEST_LENGTH))
        case .SHA1:     return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA1),   length: Int(CC_SHA1_DIGEST_LENGTH))
        case .SHA224:   return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA224), length: Int(CC_SHA224_DIGEST_LENGTH))
        case .SHA256:   return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256), length: Int(CC_SHA256_DIGEST_LENGTH))
        case .SHA384:   return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA384), length: Int(CC_SHA384_DIGEST_LENGTH))
        case .SHA512:   return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA512), length: Int(CC_SHA512_DIGEST_LENGTH))
        }
    }
}
// Symmetric Cryptographic Algorithm
enum kSCAType {
    case AES, AES128, DES, DES3, CAST, RC2, RC4, Blowfish
    var infoTuple: (algorithm: CCAlgorithm, digLength: Int, keyLength: Int) {
    switch self {
        case .AES:     return (CCAlgorithm(kCCAlgorithmAES),       Int(kCCKeySizeAES128),      Int(kCCKeySizeAES128))
        case .AES128:  return (CCAlgorithm(kCCAlgorithmAES128),    Int(kCCBlockSizeAES128),    Int(kCCKeySizeAES256))
        case .DES:     return (CCAlgorithm(kCCAlgorithmDES),       Int(kCCBlockSizeDES),       Int(kCCKeySizeDES))
        case .DES3:    return (CCAlgorithm(kCCAlgorithm3DES),      Int(kCCBlockSize3DES),      Int(kCCKeySize3DES))
        case .CAST:    return (CCAlgorithm(kCCAlgorithmCAST),      Int(kCCBlockSizeCAST),      Int(kCCKeySizeMaxCAST))
        case .RC2:     return (CCAlgorithm(kCCAlgorithmRC2),       Int(kCCBlockSizeRC2),       Int(kCCKeySizeMaxRC2))
        case .RC4:     return (CCAlgorithm(kCCAlgorithmRC4),       Int(kCCBlockSizeRC2),       Int(kCCKeySizeMaxRC4))
        case .Blowfish:return (CCAlgorithm(kCCAlgorithmBlowfish),  Int(kCCBlockSizeBlowfish),  Int(kCCKeySizeMaxBlowfish))
        }
    }
}


class JCryptHelp : JBaseDataModel {
    //data数据转换为base64格式字符串 加密
    class func funj_encryptBase64(_ content : String) -> String? {
        let encryData = content.data(using: .utf8)?.base64EncodedData()
        if encryData == nil { return  nil}
        let decoded = String(data: encryData!, encoding: .utf8)
        return decoded
    }
    //base64格式字符串转换为data 解密
    class func funj_dencryptBase64(_ content : String) -> String? {
        let decodedData = Data(base64Encoded: content)
        if decodedData == nil { return nil }
        let decodedString = String(data: decodedData!, encoding: .utf8)
        return decodedString
    }
    //md5 加密
    class func funj_encryptMD5(_ content : String?) -> String?{
        return funj_shaCrypt(string: content, cryptType: .MD5, key: funj_getEncryptKey(nil), lower: true ,base64: false)
    }

    class private func funj_getEncryptKey(_ key1 : String?) -> String? {
        var key = key1 ?? "DevelopArchitecture"
        key += "DevelopArchitecture"
        var dataStr = funj_shaCrypt(string: key, cryptType: .MD5, key: nil, lower: true ,base64: false)
        dataStr = (dataStr ?? "") +  "O(#_@+KDOW(@>DI(!||{#(@12"
        return funj_shaCrypt(string: dataStr, cryptType: .MD5, key: nil, lower: true ,base64: false)
    }
}
extension JCryptHelp{
    // MD5 SHA1 SHA256 SHA512 这4种本质都是摘要函数，不通在于长度  MD5 是 128 位，SHA1  是 160 位 ，SHA256  是 256 位
    public static func funj_shaCrypt(string: String?, cryptType: kSHAType, key: String?, lower: Bool ,base64 : Bool) -> String? {
        guard let cStr = string?.cString(using: String.Encoding.utf8) else {
            return nil
        }
        // let strLen = Int(string!.lengthOfBytes(using: String.Encoding.utf8))
        let strLen  = strlen(cStr)
        let digLen = cryptType.infoTuple.length
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digLen)
        let hash = NSMutableString()

        if let cKey = key?.cString(using: String.Encoding.utf8), key != "" {
            let keyLen = Int(key!.lengthOfBytes(using: String.Encoding.utf8))
            CCHmac(cryptType.infoTuple.algorithm, cKey, keyLen, cStr, strLen, buffer)
        } else {
            switch cryptType {
            case .MD5:      CC_MD5(cStr,    (CC_LONG)(strlen(cStr)), buffer)
            case .SHA1:     CC_SHA1(cStr,   (CC_LONG)(strlen(cStr)), buffer)
            case .SHA224:   CC_SHA224(cStr, (CC_LONG)(strlen(cStr)), buffer)
            case .SHA256:   CC_SHA256(cStr, (CC_LONG)(strlen(cStr)), buffer)
            case .SHA384:   CC_SHA384(cStr, (CC_LONG)(strlen(cStr)), buffer)
            case .SHA512:   CC_SHA512(cStr, (CC_LONG)(strlen(cStr)), buffer)
            }
        }
        if(base64){
            let data = Data(bytes: buffer, count: Int(digLen))
            hash.appending(data.base64EncodedString())
        }else{
            for i in 0..<digLen {
                if lower {
                    hash.appendFormat("%02x", buffer[i])
                } else {
                    hash.appendFormat("%02X", buffer[i])
                }
            }
        }
        free(buffer)
        return hash as String
    }
    public static func funj_scaCrypt(string: String?, cryptType: kSCAType, key: String?, encode: Bool) -> String? {

        if string == nil {
            return nil
        }
        let strData = encode ? string!.data(using: .utf8) : Data(base64Encoded: string!)
        if strData == nil { return nil}
        // 创建数据编码后的指针
        let dataPointer = UnsafeRawPointer((strData! as NSData).bytes)
        // 获取转码后数据的长度
        let dataLength = size_t(strData!.count)
        // 将加密或解密的密钥转化为Data数据
        guard let keyData = key?.data(using: .utf8) else {
            return nil
        }
        // 创建密钥的指针
        let keyPointer = UnsafeRawPointer((keyData as NSData).bytes)
        // 设置密钥的长度
        let keyLength = cryptType.infoTuple.keyLength

        // 创建加密或解密后的数据对象
        let cryptData = NSMutableData(length: Int(dataLength) + cryptType.infoTuple.digLength)
        // 获取返回数据(cryptData)的指针
        let cryptPointer = UnsafeMutableRawPointer(mutating: cryptData!.mutableBytes)
        // 获取接收数据的长度
        let cryptDataLength = size_t(cryptData!.length)
        // 加密或则解密后的数据长度
        var cryptBytesLength:size_t = 0
        // 是解密或者加密操作(CCOperation 是32位的)
        let operation = encode ? CCOperation(kCCEncrypt) : CCOperation(kCCDecrypt)
        // 算法类型
        let algoritm: CCAlgorithm = CCAlgorithm(cryptType.infoTuple.algorithm)
        // 设置密码的填充规则（ PKCS7 & ECB 两种填充规则）
        let options:CCOptions = UInt32(kCCOptionPKCS7Padding) | UInt32(kCCOptionECBMode)
        // 执行算法处理
        let cryptStatus = CCCrypt(operation, algoritm, options, keyPointer, keyLength, nil, dataPointer, dataLength, cryptPointer, cryptDataLength, &cryptBytesLength)
        // 结果字符串初始化
        var resultString: String?
        // 通过返回状态判断加密或者解密是否成功
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            cryptData!.length = cryptBytesLength
            if encode {
                resultString = cryptData!.base64EncodedString(options: .lineLength64Characters)
            } else {
                resultString = NSString(data:cryptData! as Data ,encoding:String.Encoding.utf8.rawValue) as String?
            }
        }
        return resultString
    }
}

/*
 CCCrypt 函数的介绍

 1、参数1： 是指定加密还是解密的枚举类型（kCCEncrypt 、kCCDecrypt）
 2、参数2： 是指加密算法的类型。在CommonCryptor.h中提供了kCCAlgorithmAES128、kCCAlgorithmAES、kCCAlgorithmDES、kCCAlgorithm3DES、kCCAlgorithmCAST、kCCAlgorithmRC4、kCCAlgorithmRC2、kCCAlgorithmBlowfish等多种类型的加密算法
 3、 参数3：用来设置密码的填充规则（表示在使用密钥和算法对文本进行加密时的方法）的选项，该选项可以是kCCOptionPKCS7Padding或kCCOptionECBMode两者中的任一个
 4、参数4：密钥的数据指针
 5、参数5： 是密钥的长度 ，必须是 24 位
 6、参数6： 加密或者解密的偏移对象
 7、参数7： 要解密或者解密的数据指针对象
 8、参数8： 要解密或者解密的数据字符长度
 9、参数9： 加密或者解密的数据指针
 10、参数10： 接受加密或者解密的数据长度
 11、参数11： 这是加密或者解密的数据长度


 注意
 在加密或者解密的结果输出的时候，要重新设置接受解密或者加密的数据对象的长度为真实长度。

 CCCrypt 的返回结果
 1、kCCSuccess    加解密操作正常结束
 2、kCCParamError 非法的参数值
 3、kCCBufferTooSmall 选项设置的缓存不够大
 4、kCCMemoryFailure 内存分配失败
 5、kCCAlignmentError 输入大小匹配不正确
 6、kCCDecodeError 输入数据没有正确解码或解密
 7、kCCUnimplemented 函数没有正确执行当前的算法
 
 //        let base64Encoded = "YW55IGNhcm5hbCBwbGVhc3VyZS4="
 //        let decodedData = Data(base64Encoded: base64Encoded)!
 //        let decodedString = String(data: decodedData, encoding: .utf8)! //原字符串
 //        let dd = decodedString.data(using: .utf8)?.base64EncodedData()
 //        let d = String(data: dd!, encoding: .utf8)
 */

