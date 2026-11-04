# Development Workflows — CURRENT STATE

## 環境
- CAD 源檔：OpenSCAD `current/cat_treat_feeder_v1_14.scad`。
- STL 幾何檢查：Python 3.11、trimesh 4.x、numpy 1.24+；GitHub Actions workflow 提供安裝與執行基準。
- 3D 印表機、PETG、切片器型號因使用者環境而異；屬**待確認**，不可假定一致。

## 已知可用的最小檢查
```bash
python scripts/validate_stl.py
```
本命令在本地整理環境對四個 V1.14 STL 通過 watertight、winding、單一實體和正體積檢查。遠端 CI 狀態以 GitHub Actions 實際結果為準。

## 依 OpenSCAD 產生 STL（候選命令，尚未在新遠端環境驗收）
```bash
openscad -o base_body.stl -D 'part="body_side_print"' current/cat_treat_feeder_v1_14.scad
openscad -o slider.stl -D 'part="slider_print"' current/cat_treat_feeder_v1_14.scad
openscad -o front_coupon.stl -D 'part="front_snap_coupon"' current/cat_treat_feeder_v1_14.scad
openscad -o two_point_coupon.stl -D 'part="two_clip_spacing_coupon"' current/cat_treat_feeder_v1_14.scad
```
執行前須核對 SCAD 的 `part` selector；OpenSCAD 版本、輸出尺寸、輸出實體一致性仍待本機實測。

## 列印／試裝 SOP
1. PETG 參考起始值：0.2 mm 層高、4 道外牆、25–35% 填充（非保證）。
2. 先印前端小試片，再印 52 mm 連體試片，最後才印整組底座與滑塊。
3. 有應力發白、裂痕、過度變形、滑塊卡滯、手感需強行扭轉則停止。
4. V1.14 側立列印，重新確認前緣擋板共面與支撐預覽。
5. 先空載測試滑塊，再檢查肉泥出口落點、手指夾傷與貓咪舔食時的安全性。

## 完成定義
- CAD/STL 必須封閉、單一連通、正體積，前後卡扣位置吻合；滑軌對稱且滑塊整段無碰撞。
- 對風險較高的卡扣變更必須有**實物試印結果**，不能以 CAD PASS 代替。
- 修改尺寸須更新 `docs/measurements.md`、`.codex/contracts.md`、相關 current docs／backlog。
