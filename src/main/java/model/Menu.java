// データの入れ物
package model;

public class Menu {
	private int id;
    private String name;
    private int price;

    // コンストラクタ
    public Menu(int id, String name, int price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }

    // ゲッター（値を外部から読み取るために必要）
    public int getId() { return id; }
    public String getName() { return name; }
    public int getPrice() { return price; }
}
