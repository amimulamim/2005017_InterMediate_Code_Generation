#include <iostream>

template <typename T>
class vector {
private:
    T* data;
    size_t size;
    size_t capacity;

public:
   
    vector() : data(nullptr), size(0), capacity(0) {}

    
    vector(size_t initialCapacity) {
        data = new T[initialCapacity];
        if (data == nullptr) {
            std::cerr << "Memory allocation failed" << std::endl;
            exit(EXIT_FAILURE);
        }
        size = 0;
        capacity = initialCapacity;
    }

    
    ~vector() {
        delete[] data;
    }

    
    vector(const vector& other) : size(other.size), capacity(other.capacity) {
        data = new T[capacity];
        if (data == nullptr) {
            std::cerr << "Memory allocation failed" << std::endl;
            exit(EXIT_FAILURE);
        }
        std::copy(other.data, other.data + size, data);
    }

    
    vector& operator=(const vector& other) {
        if (this != &other) {
            delete[] data;

            size = other.size;
            capacity = other.capacity;
            data = new T[capacity];
            if (data == nullptr) {
                std::cerr << "Memory allocation failed" << std::endl;
                exit(EXIT_FAILURE);
            }
            std::copy(other.data, other.data + size, data);
        }
        return *this;
    }

    
    void resizevector(size_t newCapacity) {
        T* newData = new T[newCapacity];
        if (newData == nullptr) {
            std::cerr << "Memory allocation failed" << std::endl;
            exit(EXIT_FAILURE);
        }
        std::copy(data, data + size, newData);
        delete[] data;
        data = newData;
        capacity = newCapacity;
    }

    
    void appendTovector(const T& value) {
        if (size == capacity) {
            
            resizevector(capacity == 0 ? 1 : capacity * 2);
        }
        data[size++] = value;
    }

    
    void pop_back() {
        if (size > 0) {
            --size;

            
            if (size < capacity / 2) {
                resizevector(capacity / 2);
            }
        } else {
            std::cerr << "Error: Attempt to pop from an empty array" << std::endl;
        }
    }

   
    T& operator[](size_t index) {
        if (index < size) {
            return data[index];
        } else {
            std::cerr << "Error: Index out of bounds" << std::endl;
            exit(EXIT_FAILURE);
        }
    }

    
    bool contains(const T& value) const {
        for (size_t i = 0; i < size; ++i) {
            if (data[i] == value) {
                return true;
            }
        }
        return false;
    }

    
    const T* find(const T& value) const {
        for (size_t i = 0; i < size; ++i) {
            if (data[i] == value) {
                return &data[i];
            }
        }
        return nullptr; 
    }

    
    size_t getSize() const {
        return size;
    }

    
    void display() const {
        for (size_t i = 0; i < size; ++i) {
            std::cout << data[i] << ' ';
        }
        std::cout << std::endl;
    }
};

// int main() {
//     // Example usage with int
//     vector<int> intArray;

//     // Append some elements
//     for (int i = 0; i < 10; ++i) {
//         intArray.appendTovector(i);
//     }

//     // Access elements using []
//     std::cout << "Element at index 3: " << intArray[3] << std::endl;

//     // Find elements
//     int elementToFind = 5;
//     if (intArray.contains(elementToFind)) {
//         std::cout << "Element " << elementToFind << " found in the array" << std::endl;
//     } else {
//         std::cout << "Element " << elementToFind << " not found in the array" << std::endl;
//     }

//     // Find element and return pointer
//     const int* foundElement = intArray.find(elementToFind);
//     if (foundElement != nullptr) {
//         std::cout << "Element " << elementToFind << " found at address " << foundElement << std::endl;
//     } else {
//         std::cout << "Element " << elementToFind << " not found in the array" << std::endl;
//     }

//     // Display the elements
//     std::cout << "Int Array: ";
//     intArray.display();

//     // Display the size
//     std::cout << "Int Array Size: " << intArray.getSize() << std::endl;

//     // Pop an element
//     intArray.pop_back();
//     for(int i=0 ;i<intArray.getSize();i++) {
//         //int x=intArray[i];
//         std::cout<<intArray[i] << std::endl;
//     }
//     return 0;
// }
