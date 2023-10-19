// vector or table
module collections::vector {
    use std::vector;

    // Vector of specified type
    struct Widget {}
    struct WidgetVector {
        widgets: vector<Widget>
    }

    // Vector of generic type
    struct GenericVector <T> {
        values: vector<T>
    }

    // Create a GEneric Vector
    public fun create<T>(): GenericVector<T>{
        GenericVector {
            values: vector::empty<T>()
        }
    } 

    public fun put<T> (vec: &mut GenericVector<T>, value: T){
        vector::push_back<T>(&mut vec.values, value);
    }

    public fun remove<T> (vec: &mut GenericVector<T>) : T{
        vector::pop_back(&mut vec.values)
    }

    public fun length<T> (vec: &GenericVector<T>): u64{
        vector::length<T>(&vec.values)
    }
}

module collections::table{
    use sui::table::{Table, Self};
    use sui::tx_context::{TxContext};
    // key: copy+drop+store
    // value: store

    // Specified type
    struct IntegerTable {
        table_values: Table<u8,u8>
    }


    struct GenericTable<phantom K: copy + drop + store, phantom V:store>{
        table_values: Table<K,V>
    }

    // new generic table
    public fun create<K: copy + store+ drop, V: store>(ctx: &mut TxContext): GenericTable<K,V>{
        GenericTable<K,V>{
            table_values: table::new<K,V>(ctx)
        }
    }

    public fun add<K: copy + store+ drop, V: store>(table: &mut GenericTable<K,V>, k:K, v: V){
        table::add(&mut table.table_values, k, v)
    }

    public fun remove<K: copy + store+ drop, V: store>(table: &mut GenericTable<K,V>, k: K): V {
        table::remove(&mut table.table_values, k)
    }

        // Borrows an immutable reference to the value associated with the key in GenericTable
    public fun borrow<K: copy + drop + store, V: store>(table: &GenericTable<K, V>, k: K): &V {
        table::borrow(&table.table_values, k)
    }

    /// Borrows a mutable reference to the value associated with the key in GenericTable
    public fun borrow_mut<K: copy + drop + store, V: store>(table: &mut GenericTable<K, V>, k: K): &mut V {
        table::borrow_mut(&mut table.table_values, k)
    }

    /// Check if a value associated with the key exists in the GenericTable
    public fun contains<K: copy + drop + store, V: store>(table: &GenericTable<K, V>, k: K): bool {
        table::contains<K, V>(&table.table_values, k)
    }

    /// Returns the size of the GenericTable, the number of key-value pairs
    public fun length<K: copy + drop + store, V: store>(table: &GenericTable<K, V>): u64 {
        table::length(&table.table_values)
    }

}