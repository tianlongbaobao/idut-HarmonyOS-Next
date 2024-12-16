/*
 * The MIT License (MIT)
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */

'use strict';

import buildURL from '../../../lib/helpers/buildURL.js';
import settle from "../../../lib/core/settle";
import AxiosError from '../../../lib/core/AxiosError';
import buffer from '@ohos.buffer';
import util from '@ohos.util';
import { setOptions, judgeMaxContentLength } from './index';
import { LogUtil } from '../../LogUtil'

const part = '/data/storage/';

/**
 * 根据已知文件路径，获取文件名。例如输入: internal://cache/temp.jpg, 输出: temp.jpg
 * path: 文件路径
 */
function getFileNameByPath(path) {
    let index = path.lastIndexOf("/");
    let fileName = path.substr(index + 1);
    return fileName;
}

/**
 * 获取 file：  name、contentType、remoteFileName、data、 filePath
 * 1.如果是uri，filePath 直接赋值
 * 2.如果是ArrayBuffer，data 直接赋值，若有option给remoteFileName赋值
 * 3.如果是字符， 存入临时变量data[]，然后给remoteFileName 赋值
 * @param requestData
 * @param reject
 */
function getFileList(requestData, reject, cacheDir) {
    let files = [];
    let data = [];
    requestData.forEach((value, key, option) => {
        // 如果data为空，则必须设置filePath
        if (typeof (value) === 'string' && value.indexOf('internal://') == 0 && cacheDir) { // uri
            // 1、兼容：internal:// + context
            let filename = option && option.filename ? option.filename : getFileNameByPath(value)
            let type = option && option.type ? option.type : getType(filename)
            let restStr = value.split('internal://')[1]
            let defaultDir = cacheDir.split('/cache')[0]
            files.push({
                name: key,
                contentType: type,
                remoteFileName: filename,
                data: '',
                filePath: defaultDir + '/' + restStr
            })
        } else if (typeof (value) === 'string' && value.indexOf(part) == 0) {
            let filename = option && option.filename ? option.filename : getFileNameByPath(value)
            let type = option && option.type ? option.type : getType(filename)
            files.push({
                name: key,
                contentType: type,
                remoteFileName: filename,
                data: '',
                filePath: value
            })
        } else if (value instanceof ArrayBuffer) { // ArrayBuffer
            // 如果data有值，则filePath不会生效
            let defaultName = "default" + Date.now();
            let filename = !option ? defaultName : (typeof (option) === 'string') ? option : (option.filename ? option.filename : defaultName);
            let type = option && option.type ? option.type : ''
            let contentType = getType(filename)
            files.push({
                name: key,
                contentType: type ? type : contentType ? contentType : '',
                remoteFileName: filename,
                data: value,
                filePath: ''
            })
        } else {
            // 添加额外参数
            files.push({
                name: key,
                contentType: '',
                remoteFileName: '',
                data: value,
                filePath: ''
            })
        }
    })
    return {
        files: files,
        data: data
    }
}

/**
 * 根据已知文件路径，获取后缀名
 * path: 文件路径
 */
function getType(filename) {
    if (!filename) return ''
    let index = filename.lastIndexOf(".");
    let type = index > -1 ? filename.substr(index) : '';
    return type;
}
/**
 * htmlString: 字符串
 */
function isHTMLTag(htmlString) {
    // 正则表达式匹配HTML标签
    const tagPattern = /<[^>]+>/g; // 匹配任何不包含闭合标签的标签
    // 使用test方法检查字符串是否匹配
    return tagPattern.test(htmlString);
}
/**
 * 判断是否为json字串
 */
function isValidJson(str) {
    // JSON字符串必须以 {, [ 或 " 开始，以 }, ], 或 " 结束，且不能包含未闭合的引号
    var jsonPattern = /^[\\],:{}\\s]*$/;
    // 忽略空字符串和非字符串
    if (str === "" || typeof str !== "string") {
        return false;
    }
    // 使用正则表达式检查
    return jsonPattern.test(str);
}

/**
 * 上传
 * @param config 配置项
 * @param resolve
 * @param reject
 */
async function upload(httpConfig, resolve, reject) {
    const { httpRequest, fullPath, config } = httpConfig;
    const requestData = config.data;
    // 构建upload请求参数
    let context = config.context;
    let cacheDir = '';
    if (context && context.cacheDir) {
        cacheDir = context.cacheDir;
    }
    let list = getFileList(requestData, reject, cacheDir);
    let options = setOptions(config, options => {
        options.multiFormDataList = list.files;
    });
    // 发送upload请求
    try {
        let responseHeader = null;
        let dataFul = [];
        let resultData = null;
        // 用于订阅HTTP流式响应数据接收事件
        httpRequest.on("headersReceive", (header) => {
            responseHeader = header;
            const totalSize = Number(header['content-length']);
            if (totalSize) {
                judgeMaxContentLength(totalSize, config, reject, httpRequest, (valid) => {
                    // 校验失败，移除监听
                    if (!valid) {
                        removeEvent(httpRequest);
                    }
                });
            }
        });
        // 用于订阅HTTP流式响应数据接收进度事件
        httpRequest.on("dataSendProgress", ({sendSize,totalSize}) => {
            if (typeof config.onUploadProgress === 'function') {
                config.onUploadProgress({
                    loaded: sendSize,
                    total: totalSize
                })
            }
        });
        httpRequest.on('dataReceive', (arrayBuffer) => {
            let data = buffer.from(arrayBuffer);
            dataFul.push(data);
        });
        // 用于订阅HTTP流式响应数据接收完毕事件
        httpRequest.on('dataEnd', () => {
            removeEvent(httpRequest);
        });
        // 填写http请求的url地址，可以带参数也可以不带参数。URL地址需要开发者自定义。GET请求的参数可以在extraData中指定
        let url = buildURL(fullPath, config.params, config.paramsSerializer);
        LogUtil.debug(`upload url:${fullPath}, options: ${JSON.stringify(options)}`);
        httpRequest.requestInStream(url, options,
            (err, data) => {
                if (responseHeader) {
                    let fullBuffer = buffer.concat(dataFul);
                    if (responseHeader['content-type'] === 'gzip' || responseHeader['content-type'] === 'application/octet-stream') {
                        resultData = fullBuffer.buffer;
                    } else if (options.expectDataType === 0) { // string
                        resultData = fullBuffer.toString('utf8');
                    } else if (options.expectDataType === 2) { // arraybuffer
                        resultData = fullBuffer.buffer;
                    } else { // object 或者 默认无
                        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
                        let dest = new Uint8Array(fullBuffer.buffer);
                        let resStr = textDecoder.decodeWithStream(dest);
                        resultData = isValidJson(resStr) ? JSON.parse(resStr): resStr;
                    }
                    resultData = responseHeader.body ? responseHeader.body : resultData ? resultData : 'upload success!';
                }
                if (!err) {
                    let response = {
                        data: resultData,
                        status: data,
                        statusText: "",
                        headers: responseHeader,
                        config: config,
                        request: httpRequest
                    };
                    settle(function _resolve(value) {
                        resolve(value);
                    }, function _reject(error) {
                        reject(error);
                    }, response);
                } else {
                    removeEvent(httpRequest);
                    let {message,code} = err;
                    reject(new AxiosError(message || '', code || 0, config, null, null));
                }
            }
        )
    } catch (err) {
        reject(new AxiosError(err, AxiosError.ERR_BAD_OPTION_VALUE, config, null, null));
    }
}

// 移除监听
const removeEvent = (httpRequest) => {
    httpRequest.off('headersReceive');
    // 取消订阅HTTP流式响应数据接收事件
    httpRequest.off('dataReceive');
    // 取消订阅HTTP流式响应数据接收进度事件
    httpRequest.off('dataSendProgress');
    httpRequest.off('dataEnd');
    // 当该请求使用完毕时，调用destroy方法主动销毁
    httpRequest.destroy();
}

export default upload